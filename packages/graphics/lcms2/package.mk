PKG_NAME="lcms2"
PKG_VERSION="65c63bf"
PKG_SITE="https://github.com/mm2/Little-CMS/releases"
PKG_URL="https://github.com/mm2/Little-CMS/archive/${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="Little-CMS-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain zlib libjpeg-turbo tiff"
PKG_LONGDESC="lcms2 is a Small-footprint color management engine."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-zlib \
			      --with-threads \
			      --with-jpeg \
			      --with-tiff"

