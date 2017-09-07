PKG_NAME="lnav"
PKG_VERSION="485a931"
PKG_GIT_URL="https://github.com/tstack/lnav"
PKG_DEPENDS_HOST="toolchain sqlite"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_host() {
  cd $ROOT/$PKG_BUILD
  autoreconf --verbose --install --force -I m4
  export CXXFLAGS="$CXXFLAGS -D_DEFAULT_SOURCE"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --enable-silent-rules --with-pcre --disable-shared --enable-static"
