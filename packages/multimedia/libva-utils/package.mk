PKG_NAME="libva-utils"
PKG_VERSION="1.8.3"
PKG_SITE="https://github.com/01org/libva-utils/releases"
PKG_URL="https://github.com/01org/libva-utils/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain readline intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-drm --enable-x11 --disable-wayland"
