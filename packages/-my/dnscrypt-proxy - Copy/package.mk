PKG_NAME="dnscrypt-proxy"
PKG_VERSION="bbae349"
PKG_URL="https://github.com/jedisct1/dnscrypt-proxy/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libsodium"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  export CFLAGS="$CFLAGS -fomit-frame-pointer -fdata-sections -ffunction-sections"
  export CPPFLAGS="-Wl,-gc-sections"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --datarootdir=/storage/.config/dnscrypt-proxy \
			   --libdir=/storage/.config/dnscrypt-proxy/lib \
			   --enable-static \
			   --disable-shared \
			   --disable-ssp \
			   --with-gnu-ld"
			   
