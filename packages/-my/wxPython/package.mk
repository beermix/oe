PKG_NAME="wxPython"
PKG_VERSION="wxPython-4.0.0a3"
PKG_GIT_URL="https://github.com/wxWidgets/Phoenix"
PKG_DEPENDS_TARGET="toolchain libX11 setuptools:host libpng libjpeg-turbo gtk+ pango"
PKG_SECTION="service/system"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-gui"
