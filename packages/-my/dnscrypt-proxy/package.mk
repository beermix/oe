PKG_NAME="dnscrypt-proxy"
PKG_VERSION="b2a1ba6"
PKG_GIT_URL="https://github.com/jedisct1/dnscrypt-proxy"
PKG_DEPENDS_TARGET="toolchain libsodium systemd"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --datarootdir=/storage/.config/dnscrypt-proxy \
			   --libdir=/storage/.config/dnscrypt-proxy/lib \
			   --enable-static \
			   --disable-shared \
			   --enable-ssp \
			   --with-gnu-ld \
			   --with-systemd \
			   --disable-plugins"
			   
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage/
#}