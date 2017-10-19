PKG_NAME="testdisk"
PKG_VERSION="07237aa"
PKG_SITE="https://git.cgsecurity.org/cgit/testdisk/log/"
PKG_URL="https://git.cgsecurity.org/testdisk.git/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline ncurses"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared" 

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"
