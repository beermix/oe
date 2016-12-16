PKG_NAME="bmon"
PKG_VERSION="4.0"
PKG_URL="https://fossies.org/linux/privat/bmon-4.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain confuse"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"