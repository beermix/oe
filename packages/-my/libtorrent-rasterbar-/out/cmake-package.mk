PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.1.1"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_1/libtorrent-rasterbar-1.1.1.tar.gz"
PKG_SOURCE_DIR="libtorrent_libtorrent-1_1_1"
PKG_DEPENDS_TARGET="toolchain boost Python2:host Python:target zlib bzip2 curl libsigc++"

PKG_SECTION="devel"

PKG_AUTORECONF="no"

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
  	-DCMAKE_INSTALL_PREFIX=/usr \
  	-DCMAKE_BUILD_TYPE=Release \
  	-Dstatic_runtime=ON \
  	-Dunicode=ON \
  	-Dshared=ON \
  	-Dlibiconv=OFF \
  	..
}