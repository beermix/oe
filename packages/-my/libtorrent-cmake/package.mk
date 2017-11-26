PKG_NAME="libtorrent-cmake"
PKG_VERSION="1.1.3"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_3/libtorrent-rasterbar-1.1.3.tar.gz"
PKG_SOURCE_DIR="libtorrent-rasterbar-1.1.3"
PKG_DEPENDS_TARGET="toolchain boost zlib bzip2 curl libsigc++"
PKG_SECTION="devel"




#PKG_CMAKE_OPTS_TARGET="-Ddht=ON \
#		       -Dlogging=OFF \
#		       -Dstatic_runtime=ON \
#		       -Dunicode=ON \
#		       -Dshared=ON \
#		       -DCMAKE_BUILD_TYPE=Release"