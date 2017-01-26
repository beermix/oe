PKG_NAME="bully"
PKG_VERSION="1.0-22"
PKG_URL="https://dl.dropboxusercontent.com/s/s8qsadctg9m00tr/bully-1.0-22.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   export MAKEFLAGS="-j1"
}

