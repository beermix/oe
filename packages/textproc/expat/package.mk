PKG_NAME="expat"
PKG_VERSION="R_2_2_1"
PKG_GIT_URL="https://github.com/libexpat/libexpat"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

#post_unpack() {
#  rm $PKG_BUILD/expat/README
#  cp -r $PKG_BUILD/expat/* $PKG_BUILD/
#}

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DBUILD_doc=OFF -DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"