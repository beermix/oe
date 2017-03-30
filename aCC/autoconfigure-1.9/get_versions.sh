#!/bin/sh
#
#  linux/scripts/get_versions.sh : Get versions of kernel or of tools.
#
#  Copyright (C) 2001  Giacomo A. Catenazzi  <cate@debian.org>
#  This is free software, see GNU General Public License 2 for details.
#
#  1.6 (2001/12/01 16:40:27) by cate
#  Maintainer: Giacomo Catenazzi <cate@debian.org>
#  Home: http://people.debian.org/~cate/files/autoconfigure/
#  Mailing List: kbuild-devel@lists.sourceforge.net
#

#
# Usage:
#   get the version of installed tools
#     get_version.sh [ --debug ] [ --build | --target ]
#   get the version of the kernel sources (in a comparable format)
#     scripts/get_version.sh --kernel [ --debug ]
#
#  --debug : Print verbose info
#  --build : Check only build-time tools (for a cross-compile env)
#  --target : Check only target-time tools
#

# Some utils are hidden in system dirs (as required by FHS
# because not very usefull for normal users)
PATH=$PATH:/sbin:/usr/local/sbin:/usr/sbin

## parse options ###

for opts in $@ ; do
  case "$opts" in
    --debug)
      DEBUG=y ;;
   --kernel)
      KERNEL=y ;;
   --target)
      TARGET=y ;;
   --build)
      BUILD=y ;;
  esac ;
done

if [ -z "$TARGET" -a -z "$BUILD" ]; then
  TARGET=y
  BUILD=y
fi

### define local functions ###

DQ=\"

# function: new_check [build|run|both]
# reset status
new_check () {
  if [ "$1" = "build" -a -z "$BUILD" ]; then
    STATUS=1
  elif [ "$1" = "run" -a -z "$TARGET" ]; then
    STATUS=1
  else
    STATUS=0
  fi
}

# function: get_program var default
# find and test the existence of 'var' 
get_program () {
  # Is 'var' set ? else set it to '$default'
  if [ -z "$(eval echo \$$1)" ] ; then
    if which $2 >/dev/null 2>/dev/null ; then
	eval "$1=$(which $2 2>/dev/null)"
    else
	eval "$1=$2"
    fi
  fi
  # Can I run '$var' ?
  if [ ! -x "$(which $(eval echo \$$1) 2> /dev/null)" ] ; then
    STATUS=1
  fi
}

# function: get_info section command
# print infos for debug and bug reports
get_info () {
  if [ "$DEBUG" ] ; then
    echo "--- package: $1 ---"
    shift
    $@ 2>&1
    echo
  fi
}

# get_bool var command
# set 'var' according 'command' exit code
get_bool () {
  if [ "$STATUS" = "0" ] ; then
    if eval "$2" >/dev/null 2>/dev/null; then
      echo CONFIG_$1=y
    else
      echo CONFIG_$1=n
      STATUS=1
    fi
  fi
}

# function get_ver var command
# get version
get_ver () {
  if [ "$STATUS" = "0" ] ; then
    CONFIG=$(eval $2) ; STATUS=$?
    echo CONFIG_$1=$DQ$CONFIG$DQ
  fi
}

if [ "$KERNEL" = "y" ] ; then
  VERSION=$(sed -ne 's/^VERSION *= *\(.*\)$/\1/1p' Makefile)
  PATCHLEVEL=$(sed -ne 's/^PATCHLEVEL *= *\(.*\)$/\1/1p' Makefile)
  SUBLEVEL=$(sed -ne 's/^SUBLEVEL *= *\(.*\)$/\1/1p' Makefile)
  EXTRAVERSION=$(sed -ne 's/^EXTRAVERSION *= *\(.*\)$/\1/1p' Makefile)

  TYPE=50 SUB=1
  
  case $EXTRAVERSION in
    -test*)
      TYPE=10
      SUB=${EXTRAVERSION#-test}
      ;;
    test*)
      TYPE=10
      SUB=${EXTRAVERSION#test}
      ;;
    -pre*)
      TYPE=20
      SUB=${EXTAVERSION#-pre}
      ;;
    -rc*)
      TYPE=30
      SUB=${EXTAVERSION#-rc}
      ;;
    -ac*)
      TYPE=80
      SUB=${EXTRAVERSION#-ac}
      ;;
    "")
      TYPE=50
      SUB=0
      ;;
  esac
  echo "%03d.%03d.%03d.%03d.%03d" "<$VERSION> <$PATCHLEVEL> <$SUBLEVEL> <$TYPE> <$SUB>"
  exit 0
fi

new_check build
get_program GCC gcc
get_info gcc "$GCC -v"
get_bool GCC "$GCC -v 2>&1 | grep -sq 'gcc version' - "
get_ver GCC_VERSION "$GCC --version"

new_check build
get_program MAKE make
get_info make "$MAKE --version"
get_bool GNU_MAKE "$MAKE --version | grep -sq 'GNU Make' - "
get_ver MAKE_VERSION "$MAKE --version | sed -ne 's/^GNU Make version \([-0-9.a-zA-Z]*\).*$/\1/p' - "

new_check build
get_program LD ld
get_info binutils "$LD --version"
get_bool GNU_LD "$LD --version | grep -sq 'GNU ld' - "
get_ver LD_VERSION "$LD --version | sed -ne 's/^GNU ld \([-0-9.a-zA-Z]*\)$/\1/p;s/^GNU ld version \([0-9][-0-9.a-zA-Z]*\) .*$/\1/p' - "

new_check run
get_program LSMOD lsmod
get_info modutils "$LSMOD -V"
get_bool LINUX_LSMOD "which $LSMOD"
get_ver MODUTILS_VERSION "$LSMOD -V 2>&1 | sed -ne 's/lsmod version \([-0-9.a-zA-Z]*\)$/\1/p' - "

new_check run
get_program UTIL_LINUX mount
get_info util-linux "$UTIL_LINUX --version"
get_bool UTIL_LINUX "which $UTIL_LINUX"
get_ver UTIL_LINUX_VERSION "$UTIL_LINUX --version | sed -ne 's/^.*mount-\([-0-9.a-zA-Z]*\)$/\1/p' - "

# pppd need su privileges to run!
new_check run
get_program PPPD pppd
get_info ppp "$PPPD --version"
get_bool PPP "which $PPPD"
get_ver PPP_VERSION "$PPPD --version 2>&1 | sed -ne 's/^pppd version \([-0-9.a-zA-Z]*\)$/\1/p' - "

new_check run
get_program E2FSCK e2fsck
get_info e2fsprogs "$E2FSCK -V"
get_bool E2FS "which $E2FSCK"
get_ver E2FS_VERSION "$E2FSCK -V 2>&1 | sed -ne 's/^e2fsck \([-0-9.a-zA-Z]*\).*$/\1/p' - "

new_check run
get_program CARDMGR cardmgr
get_info pcmcia-cs "$CARDMGR -V"
get_bool PCMCIA "which $CARDMGR"
get_ver PCMCIA_VERSION "$CARDMGR -V 2>&1 | sed -ne 's/^cardmgr version \([-0-9.a-zA-Z]*\)$/\1/p' - "

exit 0

