PKG_NAME="bzip2-cmake"
#PKG_VERSION="0496eaa"
PKG_VERSION="3ac9ab1"
PKG_LICENSE="GPL"
#URL="https://github.com/sspring/bzip2_cmake"
#URL=="https://github.com/osrf/bzip2_cmake"
PKG_URL="https://github.com/sspring/bzip2_cmake/archive/${PKG_VERSION}.tar.gz"
#PKG_URL="https://github.com/osrf/bzip2_cmake/archive/${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="bzip2_cmake-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain bzip2:host"
PKG_BUILD_FLAGS="+pic:host +pic"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  ln -s libbz2.so $INSTALL/usr/lib/libbz2.so.1.0
  ln -s libbz2.so $INSTALL/usr/lib/libbz2.so.1.0.4
}
