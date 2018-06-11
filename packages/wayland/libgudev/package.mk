PKG_NAME="libgudev"
PKG_VERSION="232"
PKG_URL="http://ftp.acc.umu.se/pub/GNOME/sources/libgudev/$PKG_VERSION/libgudev-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="devel"

PKG_CONFIGURE_OPTS_TARGET="--disable-umockdev"
