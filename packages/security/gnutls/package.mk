PKG_NAME="gnutls"
PKG_VERSION="3.5.8"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libidn nettle gmp"
PKG_SECTION="xmedia/depends"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

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
			      --with-included-unistring \
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
