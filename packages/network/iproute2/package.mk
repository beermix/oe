KG_NAME="iproute2"
PKG_VERSION="4.13.0"
PKG_URL="https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libelf-compat linux iptables libmnl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  echo "TC_CONFIG_IPSET:=n" >> $ROOT/$PKG_BUILD/Config
  echo "TC_CONFIG_XT:=n" >> $ROOT/$PKG_BUILD/Config
  echo "HAVE_BERKELEY_DB:=n" >> $ROOT/$PKG_BUILD/Config
  
  sed "s,-I/usr/include/db3,," $ROOT/$PKG_BUILD/Makefile
        sed "s,^KERNEL_INCLUDE.*,KERNEL_INCLUDE=$(get_pkg_build linux)/include," \
                $ROOT/$PKG_BUILD/Makefile
        sed "s,^LIBC_INCLUDE.*,LIBC_INCLUDE=$SYSROOT_PREFIX/include," \
                $ROOT/$PKG_BUILD/Makefile
                
  export CC="$CC"
  export CFLAGS="$CFLAGS"
  export CXXFLAGS="$CXXFLAGS"
  export CPPFLAGS="$CPPFLAGS"
  export LDFLAGS="$LDFLAGS"
}

#make_target() {
#  make SHELL='sh -x'
#}