PKG_NAME="mesa-demos"
PKG_VERSION="8.3.0"
PKG_URL="ftp://ftp.freedesktop.org/pub/mesa/demos/8.3.0/mesa-demos-8.3.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11"
PKG_SECTION="service/system"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld"
