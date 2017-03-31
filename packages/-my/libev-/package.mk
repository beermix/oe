PKG_NAME="libev"
PKG_VERSION="4.24"
PKG_URL="http://dist.schmorp.de/libev/libev-$PKG_VERSION.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}