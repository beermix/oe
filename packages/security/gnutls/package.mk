PKG_NAME="gnutls"
PKG_VERSION="3.5.14"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnutls.org"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl gmp libgpg-error nettle libgcrypt"
PKG_SECTION="xmedia/tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-included-unistring \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --with-libnettle-prefix=$SYSROOT_PREFIX/usr \
			      --with-sysroot=$SYSROOT_PREFIX \
			      --without-libiconv-prefix \
			      --without-libintl-prefix \
			      --disable-libdane \
			      --disable-tools \
			      --disable-doc \
			      --disable-nls \
			      --disable-guile \
			      --disable-valgrind-tests \
			      --without-lzo \
			      --with-gnu-ld"