PKG_NAME="gnutls"
PKG_VERSION="3.5.9"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gmp nettle libidn"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_vfork_works=no \
			      ac_cv_func_fork=no \
			      --enable-hardware-acceleration \
			      --enable-cxx \
			      --disable-shared \
			      --without-p11-kit \
			      --disable-nls \
			      --with-included-libtasn1 \
			      --enable-local-libopts \
			      --disable-doc \
			      --disable-tests \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --disable-full-test-suite \
			      --with-included-unistring \
			      --disable-tools \
			      --with-idn \
			      --with-gnu-ld \
			      --disable-rpath \
			      --without-lzo"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
