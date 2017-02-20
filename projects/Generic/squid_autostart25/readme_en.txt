============================================================
Squid autostart Install & Remove   (C) 2007,2015 Yuri Voinov
============================================================

***  ATTENTION!  The package is configured by default to run
Squid, installed in /usr/local!

*** ATTENTION! This version is designed to run Squid as user
root!  After  starting  there is a decrease of privileges to
cache_effective_user.

***  Note: By default, the log cache recording is enabled in
cache.log.   To   start  recording  log  using  SYSLOG,  use
TO_SYSLOG option in init.squid.

This set of scripts for installation and removal service for
SMF Squid on Sun Solaris 10 and above and Linux (SysV init).

All  the  necessary  prerequisites needed to run the service
Squid,   according   to   the  configuration  of  Guidelines
(excluding  proper configuration Squid) performed during the
installation  of  service,  removal  service/SMF removes all
scripts and performs deregister service Squid and stop.

*** Attention! cache_effective_user should be created before
starting  the  service.  The  user is not deleted or created
according to a set of scripts.

To activate Squid autostart follow these steps:
-----------------------------------------------

0  IMPORTANT!  If  Squid  redirector  uses squidGuard, it is
important  to  remember that it requires BerkeleyDB. Path to
which   must  be  specified  in  the  variable  LD_ADD  file
init.squid.  If  squid  user  has installed shell bash, make
sure  that  the  path to the BDB correctly set in init.squid
(variable   LD_ADD).   Otherwise,  using  a  bash  with  the
corrected  Shellchoke,  run squid will be impossible. If the
version  of  BDB refreshed, and thus change the path to it -
make  sure  that the value of BDB adjusted accordingly. Also
in  this  situation, make sure that the global configuration
file /var/ld/ld.config way to BDB present.

1.  Install  Squid  and all necessary libraries, if you have
not done.

2. Confiure Squid.

3.  If  necessary,  edit  the  parameter (variable) BASE_DIR
script  init.squid,  to  point  to  the  directory where you
actually installed Squid.

***  ATTENTION!  The package is configured by default to run
Squid, installed in /usr/local!

4.  Run  the  script install.sh, which will performs all the
necessary  prerequisites  and  post-installation  steps  and
install Squid SMF/autostart service.

5.  Run  the svcadm enable squid to activate the service and
start  Squid  or  /etc/init.d/init.squid  start  (Linux)  or
restart host.

To deactivate and remove Squid autostart service follow  next
steps:
-------------------------------------------------------------

1.   Start   the  script  remove.sh.  The  script  stops all
running    processes  Squid,  unregisters  SMF/service  then
removes   Squid   SMF/method   and  rolls back the operation
performed earlier in the activation of the service.

***   Note:   Removing   Squid  autostart  service  does not
remove the installed Squid or user cache_effective_user!

SMF Service supports followin methods:
--------------------------------------
svcadm squid enabe/disable/refresh/restart

ATTENTION!
----------
If  necessary,  make  changes  to  the startup configuration
Squid  should  edit  the  required  variables  in the script
init.squid:

# Base Squid installation directory
BASE_DIR="/usr/local/squid"

# Squid files paths
SQUID_PATH="$BASE_DIR""/sbin"
SQUID_CONF_PATH="$BASE_DIR""/etc"

# Squid files
SQUID_BIN_FILE="squid"
SQUID_CONF_FILE="squid.conf"

# Squid effective user name
SQUID_USER="squid"

# Set file descriptors limit. See --with-maxfd/--with-filedescriptors option with squid configuration
MAXFD=131072

# LD_LIBRARY_PATH additional setting. Change if another bdb version is installed. Bdb uses by squidGuard
LD_ADD="/opt/csw/bdb48/lib/amd64:/opt/csw/lib/amd64"

# Log cache to syslog
# Set to Y, if your need
TO_SYSLOG="N"

It  works  in a mode of limitation RSS-max service rcap, and
/etc/project. If there is an entry in /etc/project named
user.squid:100:Squid processes:squid:squid:rcap.max-rss=<value>
and  rcap  running - maximum memory RSS Squid processes will
be limited to a predetermined value.

The archive contains:

init.squid                 - Managing method Squid autostart
squid.xml                      - Service manifesto Squid SMF
readme_en.txt                          - This file (English)
readme_ru.txt                          - Этот файл (Russian)
install.sh             - installation script Squid autostart
remove.sh                 - Script to remove Squid autostart
    
============================================================
Squid autostart Install & Remove   (C) 2007,2015 Yuri Voinov
============================================================