PKG_NAME="aircrack-ng"
PKG_VERSION="c2e20a4"
PKG_SHA256=""
PKG_URL="https://github.com/aircrack-ng/aircrack-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl libpcap openssl pcre usbutils iw"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking"
