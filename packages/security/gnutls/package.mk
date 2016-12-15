PKG_NAME="gnutls"
PKG_VERSION="3.4.17"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gmp zlib nettle"
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
			      --with-sysroot=$SYSROOT_PREFIX/usr \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --without-libiconv-prefix \
			      --without-libintl-prefix \
			      --disable-libdane \
			      --disable-doc \
			      --disable-nls \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --without-lzo \
			      --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
