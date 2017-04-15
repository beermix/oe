PKG_NAME="gnutls"
PKG_VERSION="3.5.11"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnutls.org"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib nettle"
PKG_SECTION="xmedia/tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-openssl-compatibility \
			      --enable-static \
			      --enable-libdane --without-tpm --disable-guile \
			      --disable-heartbeat-support \
			      --enable-cxx \
			      --disable-tools \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-included-libtasn1 \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --with-libiconv=$SYSROOT_PREFIX/usr \
			      --without-libintl-prefix \
			      --with-included-unistring \
			      --with-ca-bundle=/etc/ssl/cert.pem \
			      --disable-doc \
			      --disable-valgrind-tests \
			      --disable-full-test-suite \
			      --without-lzo"