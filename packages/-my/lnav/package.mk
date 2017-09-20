PKG_NAME="lnav"
PKG_VERSION="0.8.2"
PKG_URL="https://github.com/tstack/lnav/releases/download/v0.8.2/lnav-0.8.2.tar.gz"
PKG_DEPENDS_HOST="toolchain sqlite"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"




PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --enable-silent-rules --with-pcre --disable-shared --enable-static"
