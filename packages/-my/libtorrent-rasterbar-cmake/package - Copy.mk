PKG_NAME="libtorrent-rasterbar-cmake"
PKG_VERSION="1.1.1"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_1/libtorrent-rasterbar-1.1.1.tar.gz"
PKG_SOURCE_DIR="libtorrent_libtorrent-1_1_1"
PKG_DEPENDS_TARGET="toolchain boost Python:host Python:target zlib bzip2 curl netbsd-curses libsigc++"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
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