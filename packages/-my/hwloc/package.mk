PKG_NAME="hwloc"
PKG_VERSION="1.11.6"
PKG_URL="https://fossies.org/linux/misc/hwloc-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libevent libpciaccess"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-x \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-pci \
			      --enable-malloc0returnsnull"