PKG_NAME="lksctp-tools"
PKG_VERSION="18272a1"
PKG_GIT_URL="https://github.com/sctp/lksctp-tools"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-tests --disable-shared --enable-static"