PKG_NAME="fbset"
PKG_VERSION="2.1"
PKG_URL="https://dl.dropboxusercontent.com/s/6l4mm14rv1jg7os/fbset_2.1.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="audio"
PKG_SHORTDESC="DTS Coherent Acoustics decoder with support for HD extensions"
PKG_LONGDESC="DTS Coherent Acoustics decoder with support for HD extensions"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="PREFIX=/usr BINDIR=/usr/bin LIBDIR=/usr/lib"
PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
  export LDFLAGS="$LDFLAGS -fPIC -DPIC"
}
