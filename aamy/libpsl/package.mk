PKG_NAME="libpsl"
PKG_VERSION="0.18.0"
PKG_URL="https://github.com/rockdaboot/libpsl/releases/download/libpsl-$PKG_VERSION/libpsl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libunistring libidn2"
PKG_SECTION="devel"


PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --disable-static --disable-man"
