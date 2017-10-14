PKG_NAME="strongswan"
PKG_VERSION="5.5.2"
PKG_URL="https://download.strongswan.org/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl iptables gmp xl2tpd"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-all \
			      --enable-static \
			      --with-zlib-dir=$TOOLCHAIN \
			      --enable-scripts \
			      --with-random-device=/dev/random \
			      --with-urandom-device=/dev/urandom \
			      --sysconfdir=/storage/.config/strongswan \
			      --datarootdir=/storage/.config/strongswan"
		           
post_makeinstall_target() {
  rm -rf $INSTALL/storage/
}