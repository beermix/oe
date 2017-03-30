#!/bin/sh
#
#  linux/scripts/autoconfigure.sh : Automagical Kernel Configuration.
#
#  Copyright (C) 2000,2001  Giacomo Catenazzi  <cate@debian.org>
#  This is free software, see GNU General Public License 2 for details.
#
#  Version: 1.6 (2001/12/01 18:57:50) by cate
#  Maintainer: Giacomo Catenazzi <cate@debian.org>
#  Home:   http://sourceforge.net/projects/kautoconfigure/
#  Mirror: http://people.debian.org/~cate/files/kautoconfigure/
#  Mailing List: kautoconfigure-devel@lists.sourceforge.net
#  Credits:
#    Peter Samuelson [scan_PCI function]
#    William Stearns and Andreas Schwab [bash v.1 support]
#    Andreas Jellinghaus
#
# This script try to autoconfigure the Linux kernel, detecting the
# hardware (devices, ...) and software (protocols, filesystems, ...).
# It uses soft detections: no direct IO access to unknow devices, thus
# it is always safe to run this script and it never hangs, but it cannot
# detect all hardware (mainly some very old hardware).
#
# Report errors, bugs, additions, wishes and comments to our mailing
# list: <kautoconfigure-devel@lists.sourceforge.net> or directly to me
# <cate@debian.org>.
# 
# Usage:
#   General Hints:
#     you don't need super user privileges.
#     you can run this script on a target machine without the need of
#       the kernel sources.
#
# Extra information for the developers:
#   There are a lots of redundance: because user maybe has not already
#     installed the drivers (thus we use smart detection on PCI, USB,..)
#     and not all file methods are usable ('lspci' not installed,
#     '/proc' not mounted or 'dmesg' not usable).
#   We want to check the drivers that system needs, not the drivers
#     actually installed on actual system (in this case you should
#     simply check the 'System.map').
#

#--- Configuration of Autoconfigure ---#

if [ "$1" = "--debug" ]; then
    AUTOPROBE_DEBUG=y
    shift
fi
# Are we in kernel (target==host) or we are autoprobing the target
# machine ?
if [ -z "$KBUILD_OBJTREE" ]; then
    AUTOCONFIG=autoconfig
    SRCTREE=.
    OBJTREE=.
    AUTOPROBE_TMP_FILE=autoprobe.tmp
else
    AUTOCONFIG=$KBUILD_OBJTREE/autoconfig
    SRCTREE=.
    OBJTREE=$KBUILD_OBJTREE
    AUTOPROBE_TMP_FILE=$KBUILD_OBJTREE/autoprobe.tmp
fi
Null=/dev/null
if [ -x $AUTOCONFIG.out ]; then
    rm -rf $AUTOCONFIG.old
    mv $AUTOCONFIG.out autoconfig.old
fi
rm -rf $AUTOPROBE_TMP_FILE
echo "#" > $AUTOCONFIG.out
echo "# Automagically generated file. Do not edit!" >> $AUTOCONFIG.out
echo '# (Version: 1.6 (2001/12/01 18:57:50) by cate)' >> $AUTOCONFIG.out
echo "#" >> $AUTOCONFIG.out
#--- (Configuration of Autoconfigure) ---#


#--- Definition of the Configuration Interface ---#

# 'comment'      writes comments on output file
# 'debug'        writes comments only if in debug mode
#
# comment 'some comment'
# debug 'some usefull information to debug the code'
#
comment() {
    if [ "$AUTOPROBE_DEBUG" = "y" ]; then
	echo "# --- $@ ---" >> $AUTOCONFIG.out
    fi
    echo "$@"
}
debug() {
    if [ "$AUTOPROBE_DEBUG" =  "y" ]; then
	echo "## --- $@ ---" >> $AUTOCONFIG.out
    fi
}
#
# 'define'    sets configuration (general funcions)
# 'found'     sets the value 'y/m' (driver detected)
# 'found_y'   sets the value 'y' (driver detected, forces built-in)
# 'found_m'   sets the value 'm' (driver detected, build as module)
# 'found_n'   sets the value 'n' (driver not needed)
# 'provide'   sets a PROVIDE_ variable (internal variable)
#
#  The priority is: y > m > n > 'other'
#
#  Rules:
#   string and and numeric variables: 'define'
#   important configuration (needed to boot): 'found_y'
#   normal detection: 'found'
#   ...: 'found_m'
#   not needed driver/configuration: 'found_n'
#   not detected: '' (nothing)
#   internal variable: 'provide'
#
#  define    CONF  value
#  found     VAR
#  found_y   VAR_FOO
#  found_m   VAR_BAR
#  found_n   VAR_OTHER
#  provide   VAR_FOO_AND_BAR
#
define () {
    echo "CONFIG_$1=$2" >> $AUTOCONFIG.out
    eval "CONFIG_$1=$2"
}
# "${!conf}" is available only on bash2. Too new for us!
found () {
    if [ "$(eval echo \$CONFIG_$1)" != "y" ]; then
	define $1 y
    else
	debug "$1=y"
    fi
}
found_y () {
    if [ "$(eval echo \$CONFIG_$1)" != "y" ]; then
	define $1 y
    else
	debug "$1=y"
    fi
}
found_m () {
    if [ "$(eval echo \$CONFIG_$1)" != "y"  -a  "$(eval echo \$CONFIG_$1)" != "m" ]; then
	define $1 m
    else
	debug "$1=m"
    fi
}
found_n () {
    if [ -z "$(eval echo \$CONFIG_$1)" ]; then
	define $1 n
    else
	debug "$1=n"
    fi
}
provide () {
    if [ "$(eval echo \$PROVIDE_$1)" != "y" ]; then
        eval "PROVIDE_$1=y"
	debug "PROVIDE_$1"
    fi
}
#--- (Definition of Configuration Interface) ---#


#--- scan_PCI ---#

#  This function check the pci card and give as output"
#    "pci: xxxx,yyyy,zz:Class:aabb,cc"  or
#    "pci: xxxx,yyyy,ssss,rrrr,zz:Class:aabbb,cc"
#   where: xxxx,yyyy: the vendor and device id
#         ssss,rrrr: the sub-vendor and sub-device id
#         zz: revision
#         aabb,cc: Device Class, Interface
#
#  function ported in sh by Peter Samuelson.
scan_PCI () {
  for f in /proc/bus/pci/??/*; do
    set `od -An -tx1 -v $f`
    x0=$1; shift   # make variables zero-based
    echo -n "pci: ${1}${x0},${3}${2}"
    if [ "${14}" = "00" ]; then
	echo -n ",${45}${44},${47}${46}"
    fi
    echo ",${8};Class:${11}${10},${9}"
  done
}
#--- (scan_PCI) ---#


#--- Check files ---#

debug 'Check files'
if [ ! -d /proc ]; then
    comment '*** Warning: /proc not found!'
    comment '***   Detection will be incomplete!'
fi
DMESG=`which dmesg`
if [ -r /var/log/dmesg ]; then
    if [ "$DMESG"  -a  -x $DMESG ]; then
	# We use the two methods to capture both boot-time and
	# modeles-init-time dmesg
	INFODMESG=$OBJTREE/auto.dmesg
	$DMESG > $OBJTREE/auto.dmesg
	cat /var/log/dmesg >> $OBJTREE/auto.dmesg
    else
	INFODMESG=/var/log/dmesg
    fi
elif [ "$DMESG"  -a  -x "$DMESG" ]; then
    INFODMESG=$OBJTREE/auto.dmesg
    $DMESG > $OBJTREE/auto.dmesg
elif [ -r /var/log/messages ]; then
    INFODMESG=/var/log/messages
else
    INFODMESG=$Null
    comment '*** Warning: no kernel dmesg found! ***'
fi
#--- (Check files) ---#


### Begin of the autodetection ###
comment 'Begin of Autodetection'


#--- Parse "autoconfig.rules" ---#
debug 'Parse "autoconfig.rules"'

FILE_PCI=$OBJTREE/auto.pci
FILE_PNP=$OBJTREE/auto.pnp
FILE_USBP=$OBJTREE/auto.usbp
FILE_USBC=$OBJTREE/auto.usbc
FILE_USBI=$OBJTREE/auto.usbi
FILE_DEV=$OBJTREE/auto.dev
FILE_REQ=$OBJTREE/auto.req
FILE_FS=$OBJTREE/auto.fs
FILE_FS_ROOT=$OBJTREE/auto.fs-root
FILE_DMESG=$INFODMESG
FILE_NET=$OBJTREE/auto.net

scan_PCI > $AUTOPROBE_TMP_FILE
if grep -sqi '^pci: [0-9]' $AUTOPROBE_TMP_FILE; then
    provide PCI
    found PCI
fi

if grep -sqi '^[0-9]' /proc/bus/isapnp/devices ]; then
    found ISAPNP
    cat /proc/bus/isapnp/devices | sed -ne 's#^[[:graph:]][[:graph:]]*[[:blank:]][[:blank:]]*\([[:graph:]]*\)[[:blank:]].*$#isapnp: \1#gp' - >> $AUTOPROBE_TMP_FILE
fi

if grep -sqi '^.:' /proc/bus/usb/devices ]; then
    found USB
    cat /proc/bus/usb/devices | sed -ne 's#^P:.*Vendor=\([A-Fa-f0-9]*\)[[:blank:]].*ProdID=\([A-Fa-f0-9]*\).*$#usbp: \1,\2#gp' - >> $AUTOPROBE_TMP_FILE
    cat /proc/bus/usb/devices | sed -ne 's#^D:.*Cls=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*Sub=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*Prot=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*$#usbc: \1,\2,\3#gp' - >> $AUTOPROBE_TMP_FILE
    cat /proc/bus/usb/devices | sed -ne 's#^I:.*Cls=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*Sub=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*Prot=\([A-Fa-f0-9]*\)[^A-Fa-f0-9].*$#usbi: \1,\2,\3#gp' - >> $AUTOPROBE_TMP_FILE
fi

cat  /proc/mounts /etc/mtab /etc/fstab | sed -ne 's#^[[:blank:]]*[^#][[:graph:]]*[[:blank:]][[:blank:]]*[[:graph:]][[:graph:]]*[[:blank:]][[:blank:]]*\([[:graph:]][[:graph:]]*\)[[:blank:]].*$#fs: \1#gp' - >> $AUTOPROBE_TMP_FILE
cat  /proc/mounts /etc/mtab /etc/fstab | sed -ne 's#^[[:blank:]]*[^#][[:graph:]]*[[:blank:]][[:blank:]]*/[[:blank:]][[:blank:]]*\([[:graph:]][[:graph:]]*\)[[:blank:]].*$#fsr: \1#gp' - >> $AUTOPROBE_TMP_FILE

cat /proc/devices | sed -ne 's#[[:blank:]]*[0-9][0-9]*[[:blank:]][[:blank:]]*\(.*\)$#dev: \1#gp' - >> $AUTOPROBE_TMP_FILE

cat /proc/iomem /proc/ioports /proc/dma /proc/interrupts > $FILE_REQ
cat /proc/net/sockstat | sed -ne 's#^\([A-Z0-9]*\): inuse [1-9]#net: \1#gp' - >> $AUTOPROBE_TMP_FILE


check_pci () {
  if grep -sqie "^pci: $1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_pci_class () {
  if grep -sqie "^pci: .*;Class:$1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_pnp () {
  if grep -sqie "^isapnp: $1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_usbp () {
  if grep -sqie "^usbp: $1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_usbc () {
  if grep -sqie "^usbc: $1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_usbi () {
  if grep -sqie "^usbi: $1" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_fs () {
  if grep -sqe "^fsr: $1\$" $AUTOPROBE_TMP_FILE; then
    found_y $2
  elif grep -sqie "^fs: $1\$" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_dev () {
  if grep -sqe "^$1\$" $FILE_DEV; then
    found $2
  fi
}
check_cons () {
  if grep -sqe "^Console: .* $1 " $FILE_DMESG; then
    found $2
  fi
}
check_net () {
  if grep -sqe "^net: $1\$" $AUTOPROBE_TMP_FILE; then
    found $2
  fi
}
check_req () {
  if grep -sqe "$1" $FILE_REQ; then
    found $2
  fi
}
comment 'Parsing configuration database....'
comment "Tip: call  'modprobe -aq \"*\" ' before run autoprobe"
comment '.... [please wait] ....'
. $SRCTREE/autoconfigure.rules
comment 'Main detection finished'
#--- (Parse "autoconfig.rules") ---#


#--- Architecture, Processor Type & Feature ---#
debug 'Architecture, Processor Type & Features'

##Source: Makefile
ARCH=`uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/`

define ARCH "$ARCH"
provide "ARCH_$ARCH"

cpu_tmp=""
check_cpu () {
  if [ -z "$cpu_tmp" ] ; then
    if echo "$cpu_id" | egrep -sqe "$1" ; then
      # CPU detected
      found $2
      cpu_tmp="y"
    fi
  fi
}

if [ "$ARCH" = "i386" ] ; then

  vendor=$(sed -n 's/^vendor_id.*: *\([-A-Za-z0-9_]*\).*$/\1/pg' /proc/cpuinfo)
  cpu_fam=$(sed -n 's/^cpu family.*: *\([0-9A-Za-z]*\).*$/\1/pg' /proc/cpuinfo)
  cpu_mod=$(sed -n 's/^model[^a-z]*: *\([0-9A-Za-z]*\).*$/\1/pg' /proc/cpuinfo)
  cpu_name=$(sed -n 's/^model name.*: *\(.*\)$/\1/pg' /proc/cpuinfo)
  cpu_id="$vendor:$cpu_fam:$cpu_mod:$cpu_name"

  debug "$cpu_id"

  # First match

  check_cpu '^GenuineIntel:.*:.*:Pentium [67]'  M586TSC
  check_cpu '^GenuineIntel:.*:.*:Pentium MMX'   M586MMX
  check_cpu '^GenuineIntel:.*:.*:Pentium Pro'   M686
  check_cpu '^GenuineIntel:.*:.*:Pentium II\>'  M686
  # Celeron Copermine is really Pentium!!!
  check_cpu '^GenuineIntel:.*:.*:.*Copermine'   MPENTIUMIII
  check_cpu '^GenuineIntel:.*:.*:Celeron'       M686
  check_cpu '^GenuineIntel:.*:.*:Pentium III'   MPENTIUMIII
  check_cpu '^GenuineIntel:.*:.*:Pentium 4'     MPENTIUM4
  check_cpu '^GenuineIntel:4:.*:'               M486
  check_cpu '^GenuineIntel:5:[01237]:'          M586TSC
  check_cpu '^GenuineIntel:5:[48]:'             M586MMX
  check_cpu '^GenuineIntel:6:[01356]:'          M686
  check_cpu '^GenuineIntel:6:[789]:'            MPENTIUMIII
  check_cpu '^GenuineIntel:6:1[1]:'             MPENTIUMIII

  check_cpu '^AuthenticAMD:.*:.*:K5'            M586
  check_cpu '^AuthenticAMD:.*:.*:K6'            MK6
  check_cpu '^AuthenticAMD:.*:.*:Athlon'        MK7
  check_cpu '^AuthenticAMD:4:.*:'               M486
  check_cpu '^AuthenticAMD:5:[0123]:'           M586
  check_cpu '^AuthenticAMD:5:[89]:'             MK6
  check_cpu '^AuthenticAMD:5:1[01]:'            MK6
  check_cpu '^AuthenticAMD:6:[0124]:'           MK7

  check_cpu '^UMC:4:[12]:'                      M486
  check_cpu '^NexGenDriven:.*:.*:Nx586'         M386
  check_cpu '^NexGenDriven:5:0:'                M386

  check_cpu '^TransmetaCPU:.*:.*:'              MCRUSOE
  check_cpu '^GenuineTMx86:.*:.*:'              MCRUSOE

  check_cpu '^CentaurHauls:.*:.*:WinChip C6'    MWINCHIPC6
  check_cpu '^CentaurHauls:.*:.*:WinChip 2\>'   MWINCHIP2
  check_cpu '^CentaurHauls:.*:.*:WinChip 2[AB]' MWINCHIP2A
  check_cpu '^CentaurHauls:.*:.*:WinChip [34]'  MWINCHIP2A
  check_cpu '^CentaurHauls:5:4:'                MWINCHIPC6

  # default value
  check_cpu '^.*:.*:.*:'                        M386
else
    :  # ??? non INTEL [to do]
fi

if egrep -sqe '^reg' /proc/mtrr; then
    found MTRR
fi
if [ "$ARCH" = "i386" ]; then
    if egrep -sqe '^flags.*mtrr' /proc/cpuinfo; then
	found MTRR
    else
        found_n MTRR
    fi
fi
if [ "$ARCH" = "i386" ]; then
##Source: linux/i386/kernel/setup.c
    if egrep -sqe 'Use a PAE' $INFODMESG; then
	found HIGHMEM64G
##Source: linux/i386/kernel/setup.c
    elif egrep -sqe 'Use a HIGHMEM' $INFODMESG; then
	found HIGHMEM4G
    else
##Source: linux/i386/kernel/setup.c
	HIGH_MEM=`sed -n "s/\([0-9]*\)MB HIGHMEM avail.*$/\1/p" $INFODMESG`
	if [ $((3072)) -le $(($HIGH_MEM-0)) ]; then
	    found HIGHMEM64G
	elif [ ! -z $HIGH_MEM ]; then
	    found HIGHMEM3G
	else
	    found NOHIGHMEM
	fi
    fi
fi
if [ "$ARCH" = "i386" ]; then
    if egrep -sqe '^flags.*fpu.*$' /proc/cpuinfo; then
	found_n MATH_EMULATION
    elif egrep -sqe 'OK, FPU using' $INFODMESG; then
	# On old IRQ13 and new exception 16 FPU
	found_n MATH_EMULATION
    elif egrep -sqe 'Hmm, FPU using' $INFODMESG; then
	# On Pentium with FDIV bug
	found_n MATH_EMULATION
#    elif egrep -sqe 'Checking 386/387' $INFODMESG; then
#	# dmesg work
#	found MATH_EMULATION
    fi
fi
if [ "$ARCH" = "i386" ]; then
    processors_count=`sed -n 's/^processor.[[:space:]]*:[[:space:]]*\(.*\)$/\1/p' /proc/cpuinfo`
    if [ "0" != "$processors_count" ]; then
	found SMP
    fi
    unset processors_count
fi
#--- (Architecture, Processor Type & Feature) ---#


#--- General Setup ---#
debug 'General Setup'
if [ -d /proc/net ]; then
    found NET
fi
if egrep -sqe '0' /proc/bus/pci/devices  ||  egrep -sqe 'Bus' /proc/pci ]; then
    found PCI
fi
if [ "$CONFIG_PCI" ]; then
    found PCI_NAMES
fi
if [ -d /proc/sysvipc ]; then
    found SYSVIPC
fi
if [ -d /proc/sys ]; then
    found SYSCTL
fi
##Source: linux/arch/i386/kernel/acpi.c linux/drivers/pci/pci.ids
if egrep -sqe 'ACPI:.*found.* at' $INFODMESG; then
    found PM
    found ACPI
fi
##Source: linux/arch/i386/kernel/apm.c
if egrep -sqe 'apm: BIOS version ' $INFODMESG; then
    found APM
fi
##Source: linux/arch/i386/kernel/apm.c
if egrep -sqe 'apm: BIOS not found.' $INFODMESG; then
    found_n APM
fi
#
if  [ -c /dev/.devfsd ] ; then
    found DEVFS_FS
fi
#--- (General Setup) ---#

#--- Parallel Port Support ---#
debug 'Parallel Port Suppor'
if egrep -sqe 'parport' $INFODMESG; then
    found PARPORT
fi
if egrep -sqe 'parport.: PC-style' $INFODMESG; then
    found PARPORT
    found PARPORT_PC
fi
if egrep -sqe 'parport.*E[CP]P' $INFODMESG; then
    found PARPORT
    found PARPORT_1284
fi
if [ "$ARCH" = "i386"  -a  "$CONFIG_PARPORT" ]; then
    found PARPORT_PC
fi
#--- (Parallel Port Support) ---#

#--- Plug and Play configuration ---#
debug 'Plug and Play configuration'
##Source: linux/drivers/pnp/isapnp.c
if egrep -sqe 'isapnp:.*detected total' $INFODMESG; then
    found PNP
    found ISAPNP
elif egrep -sqe 'isapnp: No Plug.* card found' $INFODMESG; then
    found_n ISAPNP
fi 
#--- (Plug and Play configuration) ---#

#--- Block devices ---#
debug 'Block devices'
if egrep -sqe '^/dev/floppy|^/dev/fd' /etc/fstab /proc/mounts; then
    found BLK_DEV_FD
fi
##Source: linux/drivers/block/floppy.c
if egrep -sqe 'Floppy drive(s):*.fd[0-9]' $INFODMESG; then
    found BLK_DEV_FD
fi
#--- (Block devices) ---#

#--- IDE, ATA and ATAPI ---#
debug 'IDE, ATA and ATAPI'
if [ -d /proc/ide/ide0  -o  -d /proc/ide/ide1 ]  ||  egrep -sqe 'ide[0-3]' /proc/interrupts /proc/ioports; then
    found IDE
    found BLK_DEV_IDE
fi
if egrep -sqe 'disk' /proc/ide/hd?/media /dev/null; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDEDISK
fi
if egrep -sqe 'cdrom' /proc/ide/hd?/media /dev/null; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDECD
fi
if egrep -sqe 'tape' /proc/ide/hd?/media /dev/null; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDETAPE
fi
if egrep -sqe 'floppy' /proc/ide/hd?/media /dev/null; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDEFLOPPY
fi
if [ -d /proc/scsi/ide-scsi ]; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDESCSI
    found SCSI
fi
if [ -r /proc/ide/piix ]; then
    found IDE
    found BLK_DEV_IDE
    found BLK_DEV_IDEPCI
    found BLK_DEV_PIIX
    found PIIX_TUNING
    found IDEDMA_PCI_AUTO
elif [ "$PROVIDE_PCI" ]; then
    found_n BLK_DEV_PIIX
fi
#--- (IDE, ATA and ATAPI) ---#

#--- SCSI support ---#
debug 'SCSI support'
if egrep -sqe 'Host' /proc/scsi/scsi; then
    found SCSI
fi
if egrep -sqe '^/dev/sd' /etc/fstab /proc/mounts  ||  egrep -sqe 'Direct-Access|Optical Device' /proc/scsi/scsi  ||  egrep -sqe '^sd[0-9]' $INFODMESG; then
    found SCSI
    found BLK_DEV_SD
fi
if  egrep -sqe '^/dev/st' /etc/fstab /proc/mounts  ||  egrep -sqe 'Sequential-Access' /proc/scsi/scsi  ||  egrep -sqe '^st[0-9]' $INFODMESG; then
    found SCSI
    found BLK_DEV_ST
fi
if egrep -sqe '^/dev/scd' /etc/fstab /proc/mounts  ||  egrep -sqe 'CD-ROM' /proc/scsi/scsi  ||  egrep -sqe '^sr[0-9]' $INFODMESG; then
    found SCSI
    found BLK_DEV_SR
fi
if egrep -sqe '^/dev/sg' /etc/fstab /proc/mounts  ||  egrep -sqe 'Scanner|Processor' /proc/scsi/scsi; then
    found SCSI
    found BLK_DEV_SG
fi
#- SCSI low level drivers -#
debug 'SCSI low level drivers'
if [ -d /proc/scsi/imm ]; then
    found SCSI
    found_m SCSI_IMM
    found PARPORT
fi
if [ -d /proc/scsi/ppa ]; then
    found SCSI
    found_m SCSI_PPA
    found PARPORT
fi
#- (SCSI low level drivers) -#
#--- (SCSI support) ---#

#--- Network device support ---#
debug 'Network device support'
#- Ethernet -#
debug '- Ethernet -'
if egrep -sqe 'eth[0-3]' $INFODMESG; then
    found NETDEVICES
    found NET_ETHERNET
fi
#- (Ethernet) -#
#--- (Network device support) ---#

#--- Character Devices ---#
debug 'Character Devices'
pts_count=`cat $INFODMESG | sed -n 's/^pty: \([0-9]*\) Unix98 ptys.*$/\1/p' | tail -n 1 -`
if [ -n "$pts_count" ]; then
    found UNIX98_PTYS
    define UNIX98_PTY_COUNT "$pts_count"
fi
unset pts_count
if egrep -sqe 'pty' /proc/tty/drivers /proc/devices; then
    found UNIX98_PTYS
fi
#- Mouse -#
debug '- Mouse -'
if egrep -sqe 'PS/2 Mouse' /proc/interrupts; then
    found MOUSE
    found PSMOUSE
    provide MOUSE
fi
if [ "$PROVIDE_MOUSE" ]; then
    found_n BUSMOUSE
    found_n ATIXL_BUSMOUSE
    found_n LOGIBUSMOUSE
    found_n MS_BUSMOUSE
    found_n MOUSE
    found_n PSMOUSE
    found_n 82C710_MOUSE
    found_n PC110_PAD
fi
#- (Mouse) -#
#- I2C -#
debug '- I2C -'
if egrep -sqe 'SMBus' /proc/ioports; then
    found I2C
fi
#- (I2C) -#
#--- (Character Devices) ---#

#--- USB Support ---#
debug 'USB Support'
if egrep -sqe 'scanner.c: USB ' $INFODMESG; then
    found USB
    found USB_SCANNER
fi
#--- (USB Support) ---#

#--- Console drivers ---#
debug 'Console drivers'
##Section: Console

#- Frame Buffer -#
debug '- Frame Buffer -'
if egrep -sqe 'fb' /proc/devices  ||  egrep -sqe 'framebuffer|frame buffer' $INFODMESG; then
    found FB
fi
if egrep -sqe 'matroxfb' $INFODMESG; then
    found FB_MATROX
fi
if egrep -sqe 'ATI.*Mach64' /proc/ioports; then
    found FB_ATY
fi
#- (Frame Buffer) -#
#--- (Console drivers) ---#

comment 'End of Autodetection'

true
