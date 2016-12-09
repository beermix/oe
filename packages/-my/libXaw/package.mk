PKG_NAME="libXaw"
PKG_VERSION="1.0.13"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros randrproto libX11 libXrender libXext libXpm"

PKG_SECTION="x11/lib"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"