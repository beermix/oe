PKG_NAME="bdwgc"
PKG_VERSION="d8bfa89"
PKG_URL="https://github.com/ivmai/bdwgc/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libatomic_ops"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --disable-debug"