PKG_NAME="expat"
PKG_VERSION="2.2.2"
PKG_URL="https://dl.dropboxusercontent.com/s/hqqh8wtm15ocd5q/expat-2.2.2.tar.bz2"
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

PKG_CMAKE_OPTS_TARGET="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=ON"

PKG_CMAKE_OPTS_HOST="-DBUILD_tools=OFF -DBUILD_examples=OFF -DBUILD_tests=OFF -DBUILD_shared=OFF"

pre_make_host() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}

pre_make_target() {
  # fix builderror when building in subdirs
  cp -r ../doc .
}