PKG_NAME="gnutls"
PKG_VERSION="3.5.10"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_vfork_works=no \
			      ac_cv_func_fork=no \
			      --enable-hardware-acceleration \
			      --with-included-libtasn1 \
			      --enable-local-libopts \
			      --disable-doc \
			      --disable-shared \
			      --disable-tests \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --disable-full-test-suite \
			      --with-included-unistring \
			      --without-p11-kit \
			      --disable-libdane \
			      --disable-nls \
			      --disable-tools \
			      --disable-crywrap \
			      --without-idn \
			      --disable-shared"

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#}
