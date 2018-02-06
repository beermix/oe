PKG_NAME="hwloc"
PKG_VERSION="2.0.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_SECTION="security"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
   export CXXFLAGS="$CXXFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --with-x \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-plugins \
			      --enable-pci"
			      
post_makeinstall_target() {
  rm -rf $INSTALL
}