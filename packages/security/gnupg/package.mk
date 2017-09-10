PKG_NAME="gnupg"
PKG_VERSION="2.2.0"
#PKG_VERSION="1.4.22"
PKG_SITE="http://www.gnupg.org/"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/gnupg/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib curl libassuan npth libksba libgpg-error libgcrypt"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

LTO_SUPPORT="no"
GOLD_SUPPORT="no"

LIBS="$LIBS -lnettle -lhogweed -lgmp -lgnutls"

PKG_CONFIGURE_OPTS_TARGET="--with-libgpg-error-prefix=$SYSROOT_PREFIX/usr \
			      --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr \
			      --with-libassuan-prefix=$SYSROOT_PREFIX/usr \
			      --with-ksba-prefix=$SYSROOT_PREFIX/usr \
			      --with-npth-prefix=$SYSROOT_PREFIX/usr \
			      --enable-silent-rules"
