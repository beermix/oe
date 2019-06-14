PKG_NAME="libksba"
PKG_VERSION="1.3.5"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/libksba/libksba-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"



PKG_CONFIGURE_OPTS_TARGET="--with-libgpg-error-prefix=$SYSROOT_PREFIX/usr \
                           --disable-doc \
                           --disable-shared \
                           --enable-static \
                           --with-pic"

