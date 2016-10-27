PKG_NAME="libtorrent-cmake"
PKG_VERSION="599967c"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain boost zlib bzip2 curl libsigc++"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


#PKG_CMAKE_OPTS_TARGET="-Ddht=ON \
#		       -Dlogging=OFF \
#		       -Dstatic_runtime=ON \
#		       -Dunicode=ON \
#		       -Dshared=ON \
#		       -DCMAKE_BUILD_TYPE=Release"