PKG_NAME="libcroco"
PKG_VERSION="0.6.12"
PKG_SITE="http://eigen.tuxfamily.org/index.php?title=Main_Page"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/libcroco-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libxml2:host pkg-config:host"
PKG_BUILD_FLAGS="+pic:host"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"