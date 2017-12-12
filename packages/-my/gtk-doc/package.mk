PKG_NAME="gtk-doc"
PKG_VERSION="1.24"
PKG_URL="http://download.gnome.org/sources/gtk-doc/1.24/gtk-doc-$PKG_VERSION.tar.xz"
#PKG_SOURCE_DIR="libevent-c51.159cff9f5e86696f5b9a4c6f517276056258"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_BUILD_DEPENDS_HOST=""

PKG_SECTION="devel"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"