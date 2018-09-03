PKG_NAME="json-c"
PKG_VERSION="0.13.1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/json-c/json-c/wiki"
PKG_URL="https://github.com/json-c/json-c/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://s3.amazonaws.com/json-c_releases/releases/json-c-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="accessibility"
PKG_SHORTDESC="json-c"
PKG_LONGDESC="JSON-C implements a reference counting object model that allows you to easily construct JSON objects in C, output them as JSON formatted strings and parse JSON formatted strings back into the C representation of JSON objects"
PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static --disable-shared \
                           --disable-oldname-compat \
                           --enable-threading"
