PKG_NAME="expat"
PKG_VERSION="R_2_2_3"
PKG_GIT_URL="https://github.com/libexpat/libexpat"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -DXML_POOR_ENTROPY"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -DXML_POOR_ENTROPY -fPIC"
}

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

PKG_CMAKE_OPTS_HOST="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=OFF"

#pre_make_host() {
  # fix builderror when building in subdirs
#  cp -r ../doc .
#}

#pre_make_target() {
  # fix builderror when building in subdirs
#  cp -r ../doc .
#}