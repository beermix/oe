PKG_NAME="libksba"
PKG_VERSION="1.3.5"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/libksba/libksba-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gpg-error-prefix=$SYSROOT_PREFIX/lib"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}
