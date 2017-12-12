PKG_NAME="uClibc-ng"
PKG_VERSION="1.0.16"
PKG_URL="http://downloads.uclibc-ng.org/releases/1.0.16/uClibc-ng-1.0.16.tar.xz"
PKG_SOURCE_DIR="x11vnc-0.9.14"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="service/system"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
