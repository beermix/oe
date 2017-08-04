PKG_NAME="expat"
PKG_VERSION="2.2.2"
PKG_URL="https://dl.dropboxusercontent.com/s/hqqh8wtm15ocd5q/expat-2.2.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -DXML_POOR_ENTROPY"
}

#PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DBUILD_doc=OFF -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"