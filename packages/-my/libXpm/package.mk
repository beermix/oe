PKG_NAME="libXpm"
PKG_VERSION="3.5.11"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/releases/individual/lib/libXpm-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain util-macros randrproto libX11 libXrender libXext"

PKG_SECTION="x11/lib"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
