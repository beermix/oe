PKG_NAME="hwloc"
PKG_VERSION="2.0.1"
PKG_URL="https://www.open-mpi.org/software/hwloc/v1.11/downloads/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libpciaccess libtool"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --disable-cuda \
			      --disable-nvml \
			      --enable-plugins"

post_makeinstall_target() {
  rm -rf $INSTALL
}