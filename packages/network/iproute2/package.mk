KG_NAME="iproute2"
PKG_VERSION="4.10.0"
PKG_URL="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux glib iptables libmnl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  echo "HAVE_BERKELEY_DB:=n" >> Config
}

make_target() {
  make -j1 \
  CC="${CC}" \
  LDFLAGS="${LDFLAGS}" \
  DBM_INCLUDE="${SYSROOT_PREFIX}/usr/include" \
  CCOPTS="${CFLAGS} -D_GNU_SOURCE" \
  IPTC="${CFLAGS}" \
  IPTL="${LDFLAGS}" \
  SHARED_LIBS=n
}

