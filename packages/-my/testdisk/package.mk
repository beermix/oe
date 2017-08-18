PKG_NAME="testdisk"
PKG_VERSION="3b48223"
PKG_SITE="https://git.cgsecurity.org/cgit/testdisk/log/"
PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain readline netbsd-curses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared" 


PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"