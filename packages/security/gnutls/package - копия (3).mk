PKG_NAME="gnutls"
PKG_VERSION="3.4.17"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --without-p11-kit \
			      --disable-nls \
			      --with-included-libtasn1 \
			      --enable-local-libopts \
			      --disable-doc"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
