PKG_NAME="hwloc"
PKG_VERSION="2.0.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-plugins \
			      --enable-pci"
			      
post_makeinstall_target() {
  rm -rf $INSTALL
}