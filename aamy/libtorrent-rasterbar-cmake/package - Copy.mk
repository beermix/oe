PKG_NAME="libtorrent-rasterbar-cmake"
PKG_VERSION="1.1.1"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_1/libtorrent-rasterbar-1.1.1.tar.gz"
PKG_SOURCE_DIR="libtorrent_libtorrent-1_1_1"
PKG_DEPENDS_TARGET="toolchain boost Python2:host Python:target zlib bzip2 curl ncurses libsigc++"

PKG_SECTION="devel"



configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
  	-DCMAKE_INSTALL_PREFIX=/usr \
  	-Dstatic_runtime=ON \
  	-Dshared=ON \
  	-Dunicode=ON \
  	-Dpool-allocators=ON \
  	-Dlogging=OFF \
  	-Dlibiconv=OFF \
  	-Dbuild_tests=OFF \
  	-Ddeprecated-functions=OFF \
  	-Ddht=ON \
  	-Ddisk-stats=OFF \
  	-Dencryption=ON \
  	-Dexceptions=OFF
}