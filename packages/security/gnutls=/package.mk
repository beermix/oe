PKG_NAME="gnutls"
PKG_VERSION="3.5.8"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle gmp"
PKG_SECTION="security"
PKG_SHORTDESC="gnutls: Development Library for TLS applications"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --enable-hardware-acceleration \
			      --disable-openssl-compatibility \
			      --enable-cxx \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --without-libiconv-prefix \
			      --without-libintl-prefix \
			      --disable-libdane \
			      --disable-doc \
			      --without-zlib \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --without-lzo \
			      --with-gnu-ld \
			      --disable-crywrap \
			      --with-included-unistring \
			      --with-nettle-mini"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
