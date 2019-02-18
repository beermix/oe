PKG_NAME="flickcurl"
PKG_VERSION="1.26"
PKG_URL="http://download.dajobe.org/flickcurl/flickcurl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl libxml2"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared \
                           --with-pic \
                           --enable-gtk-doc=no"
