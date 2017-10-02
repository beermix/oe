PKG_NAME="hwloc"
PKG_VERSION="1.11.8"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_SECTION="security"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --without-x \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-plugins \
			      --enable-pci"
			      
post_makeinstall_target() {
  rm -rf $INSTALL
}