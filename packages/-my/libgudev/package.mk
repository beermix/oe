PKG_NAME="libgudev"
PKG_VERSION="230"
PKG_URL="https://dl.dropboxusercontent.com/s/l83iurqt48ijh1s/libgudev-230.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-gnu-ld"
			  