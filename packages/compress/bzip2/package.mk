PKG_NAME="bzip2"
PKG_VERSION="0496eaa"
#PKG_VERSION="3ac9ab1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
#URL="https://github.com/sspring/bzip2_cmake"
#URL=="https://github.com/osrf/bzip2_cmake"
#PKG_URL="https://github.com/sspring/bzip2_cmake/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/osrf/bzip2_cmake/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="bzip2_cmake-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain bzip2:host"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share
  ln -sf libbz2.so.1.0 $INSTALL/usr/lib/libbz2.so
  ln -sf libbz2.so.1.0.4 $INSTALL/usr/lib/libbz2.so 
}
