PKG_NAME="gnutls"
PKG_VERSION="3.4.16"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnutls.org"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib gmp libgpg-error nettle"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="gnutls: Development Library for TLS applications"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --enable-hardware-acceleration \
			   --disable-openssl-compatibility \
			   --disable-cxx \
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
