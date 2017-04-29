PKG_NAME="hwloc"
PKG_VERSION="d761c7b"
PKG_GIT_URL="https://github.com/open-mpi/hwloc"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
  strip_gold
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --without-x \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-pci \
			      --enable-malloc0returnsnull"