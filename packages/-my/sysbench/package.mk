PKG_NAME="sysbench"
PKG_VERSION="1.0.17"
PKG_SITE="https://github.com/akopytov/sysbench/releases"
PKG_URL="https://github.com/akopytov/sysbench/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libaio"
PKG_SHORTDESC="CSS parsing library"
PKG_TOOLCHAIN="autotools"

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
  cd $PKG_BUILD/.$HOST_NAME
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

PKG_CONFIGURE_OPTS_HOST="--without-mysql"

PKG_CONFIGURE_OPTS_TARGET="--enable-aio --with-gcc-arch=westmere --without-mysql"
