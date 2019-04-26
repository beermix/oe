PKG_NAME="patch"
PKG_VERSION="2.7.6"
PKG_URL="http://ftpmirror.gnu.org/patch/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain attr"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_sys_long_file_names=yes --enable-xattr --enable-attr"

PKG_CONFIGURE_OPTS_HOST="ac_cv_sys_long_file_names=yes"
