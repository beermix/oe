PKG_NAME="gnutls"
PKG_VERSION="3.5.10"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_vfork_works=no \
				ac_cv_func_fork=no \
				--disable-shared \
				--without-p11-kit \
				--disable-nls \
				--with-included-unistring \
				--with-included-libtasn1 \
				--enable-local-libopts \
				--disable-doc \
				--disable-tests"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
