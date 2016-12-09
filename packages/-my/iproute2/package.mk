KG_NAME="iproute2"
PKG_VERSION="4.8.0"
PKG_URL="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux glib iptables ipset libmnl"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

make_target() {
  make prefix=/usr \
       CC="$CC" \
       LD="$LD" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" all -j1
}

