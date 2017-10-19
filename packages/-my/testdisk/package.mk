PKG_NAME="testdisk"
PKG_VERSION="9897978"
PKG_SITE="https://git.cgsecurity.org/cgit/testdisk/log/"
PKG_URL="https://dl.dropboxusercontent.com/s/w40ynmkbc645tgk/testdisk-9897978.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline ncurses"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared" 

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"
