PKG_NAME="libgudev"
PKG_VERSION="230"
PKG_URL="http://ftp.acc.umu.se/pub/GNOME/sources/libgudev/$PKG_VERSION/libgudev-$PKG_VERSION.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="devel"

PKG_AUTORECONF="yes"

pre_configure_target() {
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
			  