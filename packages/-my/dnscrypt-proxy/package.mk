PKG_NAME="dnscrypt-proxy"
PKG_VERSION="a99828b"
PKG_GIT_URL="https://github.com/jedisct1/dnscrypt-proxy"
PKG_DEPENDS_TARGET="toolchain systemd libsodium"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="--datarootdir=/storage/.config/dnscrypt-proxy \
			      --libdir=/storage/.config/dnscrypt-proxy/lib \
			      --enable-static \
			      --disable-shared \
			      --disable-ssp \
			      --with-gnu-ld \
			      --with-systemd \
			      --enable-plugins"
			   
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage/
#}