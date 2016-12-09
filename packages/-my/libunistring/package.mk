PKG_NAME="libunistring"
PKG_VERSION="0.9.4"
PKG_URL="https://dl.dropboxusercontent.com/s/xsunbb965g6uyj2/libunistring-0.9.4.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain openssl"

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-gnu-ld"
			   
