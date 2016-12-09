PKG_NAME="testdisk"
PKG_VERSION="master"
PKG_GIT_URL="https://git.cgsecurity.org/testdisk.git"
PKG_DEPENDS_TARGET="toolchain"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

pre_configure_host() {
  export LIBS="-lterminfo"
}

#PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-missing-uuid-ok --with-gnu-ld"
PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"

PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"

