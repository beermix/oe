#!/bin/sh

#
# Squid autostart setup for Solaris 10,>10, Linux
# Yuri Voinov (C) 2007,2015
#
# ident "@(#)install.sh    2.5    15/12/01 YV"
#

#############
# Variables #
#############

PROGRAM_NAME="Squid"
SERVICE_NAME="squid"
SCRIPT_NAME="init.""$SERVICE_NAME"
SMF_XML="$SERVICE_NAME"".xml"
SMF_DIR="/var/svc/manifest/network"
SVC_MTD="/lib/svc/method"
BOOT_DIR="/etc/init.d"

# OS utilities    
CHOWN=`which chown`
CHMOD=`which chmod`
COPY=`which cp`
CUT=`which cut`
ECHO=`which echo`
ID=`which id`
LS=`which ls`
MKDIR=`which mkdir`
SVCCFG=`which svccfg`
SVCS=`which svcs`
UNAME=`which uname`

OS_VER=`$UNAME -r|$CUT -f2 -d"."`
OS_NAME=`$UNAME -s|$CUT -f1 -d" "`
OS_FULL=`$UNAME -sr`

if [ "$OS_NAME" = "SunOS" ]; then
 ZONENAME=`which zonename`
fi

ZONE=`$ZONENAME`

###############
# Subroutines #
###############

os_check ()
{
 if [ "$OS_NAME" = "SunOS" -a "$OS_VER" -lt "10" ]; then
  if [ "$OS_NAME" != "Linux" ]; then
   $ECHO "ERROR: Unsupported $OS_NAME version $OS_VER. Exiting..."
   exit 1
  fi
 fi
}

root_check ()
{
 if [ ! `$ID | $CUT -f1 -d" "` = "uid=0(root)" ]; then
  $ECHO "ERROR: You must be super-user to run this script."
  exit 1
 fi
}

# Non-global zones notification
non_global_zones ()
{
if [ "$ZONE" != "global" ]; then
 $ECHO "=============================================================="
 $ECHO "This is NON GLOBAL zone $ZONE. To complete installation please copy"
 $ECHO "script $SCRIPT_NAME" 
 $ECHO "to $SVC_MTD"
 $ECHO "in GLOBAL zone manually BEFORE starting service by SMF."
 $ECHO "Note: Permissions on $SCRIPT_NAME must be set to root:sys."
 $ECHO "============================================================="
fi
}

verify_svc ()
{
 # Installed service verification
 SC_NAME=$1

 $ECHO "------------ Service verificstion ----------------"
 if [ "$OS_NAME" = "SunOS" ]; then
  SVCS=`which svcs`
  $LS -al $SVC_MTD/$SCRIPT_NAME
  $LS -al $SMF_DIR/$SMF_XML
  $SVCS $SERVICE_NAME
 else
  $LS -al /etc/rc3.d/*$SERVICE_NAME
  $LS -al /etc/rc0.d/*$SERVICE_NAME
 fi
}

##############
# Main block #
##############

# Pre-inst checks
# OS version check
os_check

# Superuser check
root_check

$ECHO "-------------------------------------------"
$ECHO "- $PROGRAM_NAME autostart service will be install now   -"
$ECHO "-                                         -"
$ECHO "- Press <Enter> to continue,              -"
$ECHO "- or <Ctrl+C> to cancel                   -"
$ECHO "-------------------------------------------"
read p

if [ "$OS_NAME" = "SunOS" ]; then
 # Install for Solaris
 $ECHO "Copying $PROGRAM_NAME SMF files..."

 $COPY $SCRIPT_NAME $SVC_MTD
 $CHMOD 555 $SVC_MTD/$SCRIPT_NAME

 $COPY $SMF_XML $SMF_DIR

 $ECHO "Validate SMF method..."
 $SVCCFG validate $SMF_DIR/$SMF_XML>/dev/null 2>&1
 retcode=`$ECHO $?`
 case "$retcode" in
  0) $ECHO "*** XML service descriptor validation successful";;
  *) $ECHO "*** XML service descriptor validation has errors";;
 esac
 $ECHO "Import SMF method..."
 $SVCCFG import $SMF_DIR/$SMF_XML>/dev/null 2>&1
 retcode=`$ECHO $?`
 case "$retcode" in
  0) $ECHO "*** XML service descriptor import successful";;
  *) $ECHO "*** XML service descriptor import has errors";;
 esac
 $ECHO "Verify $PROGRAM_NAME SMF installation..."
elif [ "$OS_NAME" = "Linux" ]; then
 # Install for Linux
 $ECHO "OS: $OS_FULL"
 CHKCONFIG=`which chkconfig`
 $ECHO "Copy init script..."
 $CP $SCRIPT_NAME $BOOT_DIR/$SCRIPT_NAME>/dev/null 2>&1
 $CHOWN -R root:sys $BOOT_DIR/$SCRIPT_NAME
 $CHMOD 755 $BOOT_DIR/$SCRIPT_NAME
 # Service registration and add links
 $ECHO "Register service..."
 $CHKCONFIG --add $SCRIPT_NAME>/dev/null 2>&1
 $CHKCONFIG --level 345 $SCRIPT_NAME on>/dev/null 2>&1
 $ECHO "Verify autostart..."
else
 $ECHO "Unsupported OS: $OS_FULL"
 $ECHO "Exiting..."
 exit 1
fi

# Check for non-global zones installation   
non_global_zones

# Verify installation
verify_svc $SCRIPT_NAME
$ECHO "-------------------- Done. ------------------------"
$ECHO "Complete. Check $SCRIPT_NAME working and if true,"
$ECHO "restart host to verify."

$ECHO "If $PROGRAM_NAME services installed correctly, enable and start it now"

exit 0
##