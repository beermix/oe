PKG_NAME="testdisk"
PKG_VERSION="c0e81e1"
PKG_SITE="https://git.cgsecurity.org/cgit/testdisk/log/"
PKG_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain readline ncurses"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared" 

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"
