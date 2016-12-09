PKG_NAME="hwloc"
PKG_VERSION="15b374a"
PKG_GIT_URL="https://github.com/open-mpi/hwloc"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
#PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess cairo"

PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static \
			   --with-gnu-ld \
			   --with-x \
			   --disable-cuda \
			   --disable-nvml \
			   --enable-pci \
			   --enable-malloc0returnsnull"