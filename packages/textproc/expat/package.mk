PKG_NAME="expat"
PKG_VERSION="2.2.4"
PKG_URL="http://sources.lede-project.org/expat-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="textproc"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -DXML_POOR_ENTROPY"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -DXML_POOR_ENTROPY"
}

PKG_CMAKE_SCRIPT_TARGET="expat/CMakeLists.txt"
PKG_CMAKE_SCRIPT_HOST="expat/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

PKG_CMAKE_OPTS_HOST="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

pre_make_host() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}

pre_make_target() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}
