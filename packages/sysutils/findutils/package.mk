PKG_NAME="findutils"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-fno-plt||"
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-fno-plt||"
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,-z,now||"`
}

PKG_CONFIGURE_OPTS_TARGET="gl_cv_func_stdin=yes \
			      ac_cv_func_working_mktime=yes \
			      gl_cv_func_wcwidth_works=yes \
			      --without-selinux \
			      --disable-debug"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
