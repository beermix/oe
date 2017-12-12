PKG_NAME="spdylay"
PKG_VERSION="1.3.2"
PKG_URL="https://github.com/tatsuhiro-t/spdylay/releases/download/v1.3.2/spdylay-1.3.2.tar.xz"
PKG_SOURCE_DIR="x11vnc-0.9.14"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="service/system"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
