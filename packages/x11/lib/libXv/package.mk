PKG_NAME="libXv"
PKG_VERSION="1.0.11"
PKG_URL="https://www.x.org/archive/individual/lib/libXv-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xproto libX11 libXext"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="libXau: X authorization file management libary"
PKG_LONGDESC="X authorization file management libary"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull"
