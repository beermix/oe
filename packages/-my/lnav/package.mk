PKG_NAME="lnav"
PKG_VERSION="5268872"
PKG_URL="https://github.com/tstack/lnav/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain sqlite:host pcre:host"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"

pre_configure_host() {
  NOCONFIGURE=1 ./autogen.sh
}

#PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --enable-silent-rules --with-pcre --disable-shared --enable-static"
