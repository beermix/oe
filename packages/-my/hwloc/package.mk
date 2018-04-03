PKG_NAME="hwloc"
PKG_VERSION="1.11.10"
PKG_URL="https://www.open-mpi.org/software/hwloc/v1.11/downloads/$PKG_NAME-$PKG_VERSION.tar.bz2"
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