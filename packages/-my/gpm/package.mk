PKG_NAME="gpm"
PKG_VERSION="1.20.7"
PKG_URL="http://www.nico.schottelius.org/software/gpm/archives/gpm-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain" 
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   NOCONFIGURE=1 ./autogen.sh
   strip_hard
}

