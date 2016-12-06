PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.10"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_10/libtorrent-rasterbar-1.0.10.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl expat libiconv boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --enable-python-binding \
			      --with-libiconv \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			      
			      
#PKG_CMAKE_OPTS_TARGET="-Dunicode=ON -Dstatic_runtime=ON -Dshared=OFF -Dlibiconv=OFF -Dencryption=ON"