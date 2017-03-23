PKG_NAME="gnutls"
PKG_VERSION="3.4.17"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-ld-version-script \
			      --enable-static \
			      --without-tpm \
			      --disable-heartbeat-support \
			      --disable-shared \
			      --enable-hardware-acceleration \
			      --enable-openssl-compatibility \
			      --enable-cxx \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-included-unistring \
			      --disable-libdane \
			      --disable-doc \
			      --disable-guile \
			      --enable-tools \
			      --disable-openpgp-authentication \
			      --disable-rpath \
			      --without-nettle-mini \
			      --with-gnu-ld \
			      --disable-valgrind-tests \
			      --without-lzo \
			      --enable-silent-rules"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
