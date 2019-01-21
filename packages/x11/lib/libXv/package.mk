PKG_NAME="libXv"
PKG_VERSION="1.0.11"
PKG_URL="https://www.x.org/archive/individual/lib/libXv-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xproto libX11 libXext"
PKG_SHORTDESC="libXau: X authorization file management libary"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-malloc0returnsnull"
