PKG_NAME="libXvMC"
PKG_VERSION="1.0.10"
PKG_URL="https://www.x.org/releases/individual/lib/libXvMC-$PKG_VERSION.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull --disable-shared --enable-static"
			  