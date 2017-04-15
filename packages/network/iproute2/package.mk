KG_NAME="iproute2"
PKG_VERSION="4.10.0"
PKG_URL="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux glib iptables ipset libmnl db"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  ./configure
  export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
  
  make CC="$CC" \
  LDFLAGS="$TARGET_LDFLAGS" \
  DBM_INCLUDE="$SYSROOT_PREFIX/usr/include" \
  CCOPTS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
  SHARED_LIBS=n
    
}
