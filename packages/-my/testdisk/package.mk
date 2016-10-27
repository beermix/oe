PKG_NAME="testdisk"
PKG_VERSION="master"
PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

export LIBS="-lterminfo"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-missing-uuid-ok --prefix=/usr"
PKG_CONFIGURE_OPTS_INIT="--enable-static --disable-shared --enable-missing-uuid-ok --prefix=/usr"

#PKG_CONFIGURE_OPTS_ALL="--enable-static --disable-shared --enable-missing-uuid-ok --prefix=/usr"