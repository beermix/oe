PKG_NAME="lnav"
PKG_VERSION="v0.6.2"
PKG_GIT_URL="https://github.com/tstack/lnav"
PKG_DEPENDS_HOST="toolchain sqlite"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  NOCONFIGURE=1 ./autogen.sh
}

pre_configure_host() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  NOCONFIGURE=1 ./autogen.sh
}


PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --enable-silent-rules --with-pcre --disable-shared --enable-static"
