PKG_NAME="hwloc"
PKG_VERSION="1.11.7"
#PKG_GIT_URL="https://github.com/open-mpi/hwloc"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --without-x \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-pci \
			      --enable-malloc0returnsnull"