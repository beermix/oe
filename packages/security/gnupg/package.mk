PKG_NAME="gnupg"
#PKG_VERSION="2.2.0"
PKG_VERSION="1.4.23"
PKG_SITE="http://www.gnupg.org/"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/gnupg/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib curl npth libksba libgpg-error libgcrypt"
PKG_SECTION="security"

PKG_CONFIGURE_OPTS_TARGET="--with-libgpg-error-prefix=$SYSROOT_PREFIX/usr \
			      --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libassuan-prefix=$SYSROOT_PREFIX/usr \
			      --with-npth-prefix=$SYSROOT_PREFIX/usr \
			      --enable-silent-rules --disable-shared --with-pic"
