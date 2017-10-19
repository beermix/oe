PKG_NAME="libcap-ng"
PKG_VERSION="0.7.8"
PKG_URL="http://people.redhat.com/sgrubb/libcap-ng/libcap-ng-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="devel"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_swig_found=no \
			      --enable-static \
			      --disable-shared \
			      --with-gnu-ld \
			      --without-python3 \
			      --without-python"