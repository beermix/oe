PKG_NAME="libtorrent-rasterbar-cmake"
PKG_VERSION="master"
PKG_URL="https://github.com/arvidn/libtorrent/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="libtorrent-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain boost Python2:host Python:target zlib bzip2 curl ncurses libsigc++"

PKG_SECTION="devel"



MAKEFLAGS="-j3"

configure_target() {
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
  	-Dexceptions=ON \
  	..
}