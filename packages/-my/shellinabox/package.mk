PKG_NAME="shellinabox"
PKG_VERSION="e6c25e8"
PKG_URL="https://github.com/shellinabox/shellinabox/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
   cd $PKG_BUILD
   export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-static --disable-shared"