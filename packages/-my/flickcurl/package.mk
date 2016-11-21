PKG_NAME="flickcurl"
PKG_VERSION="1.26"
PKG_URL="http://download.dajobe.org/flickcurl/flickcurl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz openssl curl libxml2"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes--disable-shared \
			   --enable-static \
			   --enable-gtk-doc=no"
