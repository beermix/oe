#!/bin/sh

#
# Squid autostart remove for Solaris 10,>10, Linux
# Yuri Voinov (C) 2007,2015
#
# ident "@(#)remove.sh    2.5    15/12/01 YV"
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
AWK=`which awk`
CUT=`which cut`
ECHO=`which echo`
GREP=`which grep`
ID=`which id`
PKILL=`which kill`
PS=`which ps`
RM=`which rm`
SVCADM=`which svcadm`
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
non_global_zones_r ()
{
if [ "$ZONE" != "global" ]; then
 $ECHO  "================================================================="
 $ECHO  "This is NON GLOBAL zone $ZONE. To complete uninstallation please remove"
 $ECHO  "script $SCRIPT_NAME"
 $ECHO  "from $SVC_MTD"
 $ECHO  "in GLOBAL zone manually AFTER uninstalling autostart."
 $ECHO  "================================================================="
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

$ECHO "------------------------------------------"
$ECHO "- $PROGRAM_NAME autostart service will be remove now   -"
$ECHO "-                                        -"
$ECHO "- Note:                                  -"
$ECHO "- Running $PROGRAM_NAME service will be stopped! -"
$ECHO "-                                        -"
$ECHO "- Press <Enter> to continue,             -"
$ECHO "- or <Ctrl+C> to cancel                  -"
$ECHO "------------------------------------------"
read p

if [ "$OS_NAME" = "SunOS" ]; then
 # Disabling and stopping SMF service
 $ECHO "Disabling and stopping running $PROGRAM_NAME service..."
 $SVC_MTD/$SCRIPT_NAME stop
 $SVCADM -v disable $SERVICE_NAME:default

 # Remove SMF files
 $ECHO "Remove $PROGRAM_NAME SMF files..."
 if [ -f $SVC_MTD/$SCRIPT_NAME -a -f $SMF_DIR/$SMF_XML ]; then
  $RM -f $SVC_MTD/$SCRIPT_NAME

  $SVCCFG delete -f svc:/network/$SERVICE_NAME:default
  $RM $SMF_DIR/$SMF_XML
 else
  $ECHO "ERROR: $PROGRAM_NAME SMF service files not found. Exiting..."
  exit 1
 fi

 # Check for non-global zones uninstallation
 non_global_zones_r

 $ECHO "Verify $PROGRAM_NAME SMF uninstallation..."

 # Check uninstallation
 $SVCS $SERVICE_NAME>/dev/null 2>&1

 retcode=`$ECHO $?`
 case "$retcode" in
  0)
   $ECHO "*** $PROGRAM_NAME SMF service uninstallation process has errors"
   exit 1
  ;;
  *)
   $ECHO "*** $PROGRAM_NAME SMF service uninstallation successfuly"
  ;;
 esac
elif [ "$OS_NAME" = "Linux" ]; then
 # Uninstall for OS Linux
 $ECHO "OS: $OS_FULL"
 $ECHO "Stopping service..."
 ./$BOOT_DIR/$SCRIPT_NAME stop
 # Service unregistering and remove links
 $ECHO "Deregister service..."
 CHKCONFIG=`which chkconfig`
 $CHKCONFIG --del $SCRIPT_NAME>/dev/null 2>&1
 $CHKCONFIG --level 345 $SCRIPT_NAME off>/dev/null 2>&1
 $ECHO "Remove files..."
 $RM $BOOT_DIR/$SCRIPT_NAME>/dev/null 2>&1
 retcode=`$ECHO $?`
 case "$retcode" in
  0) $ECHO "*** Service deleted successfuly";;
  *) $ECHO "*** Service delete operation has errors";;
 esac
else
 $ECHO "Unsupported OS: $OS_FULL"
 $ECHO "Exiting..."
 exit 1
fi

exit 0
###