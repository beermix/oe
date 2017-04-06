PKG_NAME="gnutls"
PKG_VERSION="3.5.10"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp openssl"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--without-tpm \
			      --disable-heartbeat-support \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-included-unistring \
			      --disable-libdane \
			      --disable-doc \
			      --disable-guile \
			      --disable-openpgp-authentication \
			      --disable-rpath \
			      --without-lzo \
			      --enable-silent-rules"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  make check -j1
}
