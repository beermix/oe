PKG_NAME="libcap-ng"
PKG_VERSION="0.7.9"
PKG_URL="http://people.redhat.com/sgrubb/libcap-ng/libcap-ng-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_swig_found=no --without-python --disable-shared --enable-static"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
PKG_CONFIGURE_OPTS_INIT="$PKG_CONFIGURE_OPTS_TARGET"