PKG_NAME="lksctp-tools"
PKG_VERSION="18272a1"
PKG_GIT_URL="https://github.com/sctp/lksctp-tools"
PKG_DEPENDS_TARGET="toolchain libz"

PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-tests --disable-shared --enable-static"