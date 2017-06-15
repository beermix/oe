PKG_NAME="rhash"
PKG_VERSION="002be1b"
PKG_GIT_URL="https://github.com/rhash/RHash"
PKG_DEPENDS_HOST=""
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

pre_configure_host() {
  cd $ROOT/$PKG_BUILD

  export CFLAGS="$CFLAGS -DUSE_GETTEXT -Wall"
  export HOST_CC="gcc"
  export HOST_CXX="g++"
  export HOSTCC="$HOST_CC"
  export HOSTCXX="$HOST_CXX"
  export CC_FOR_BUILD="$HOST_CC"
  export CXX_FOR_BUILD="$HOST_CXX"
  export BUILD_CC="$HOST_CC"
  export BUILD_CXX="$HOST_CXX"
  export PREFIX="$ROOT/$TOOLCHAIN"
}

make_host() {
  make
  make -C librhash install-headers install-lib-static
}