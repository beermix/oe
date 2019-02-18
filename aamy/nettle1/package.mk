PKG_NAME="nettle"
PKG_VERSION="3.2"
PKG_URL="ftp://ftp.gnu.org/gnu/nettle/nettle-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared \
			   --disable-openssl \
			   --enable-mini-gmp \
			   CC_FOR_BUILD=$HOST_CC"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
