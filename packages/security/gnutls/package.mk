PKG_NAME="gnutls"
PKG_VERSION="3.5.11"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnutls.org"
PKG_URL="ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgcrypt libtasn1 gmp liblzo nettle libunistring"
PKG_SECTION="xmedia/tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="gl_cv_socket_ipv6=no \
			      ac_cv_header_wchar_h=yes \
			      gt_cv_c_wchar_t=yes \
			      gt_cv_c_wint_t=yes \
			      gl_cv_func_gettimeofday_clobber=no \
			      libopts_cv_with_libregex=yes \
			      --with-regex-header=pcreposix.h \
			      --enable-openssl-compatibility \
			      --enable-static \
			      --disable-crywrap \
			      --enable-libdane \
			      --without-tpm \
			      --disable-guile \
			      --disable-heartbeat-support \
			      --without-p11-kit \
			      --enable-local-libopts \
			      --with-libz-prefix=$SYSROOT_PREFIX/usr \
			      --with-librt-prefix=$SYSROOT_PREFIX \
			      --with-libpthread-prefix=$SYSROOT_PREFIX/usr \
			      --with-libnettle-prefix=$SYSROOT_PREFIX/usr \
			      --without-libintl-prefix \
			      --with-ca-bundle=/etc/ssl/cert.pem \
			      --disable-doc \
			      --disable-valgrind-tests \
			      --disable-full-test-suite \
			      --without-lzo \
			      --disable-rpath"