PKG_NAME="wxPython"
PKG_VERSION="2.8.8.0"
#PKG_GIT_URL="https://github.com/wxWidgets/wxPython"
PKG_URL="https://downloads.sourceforge.net/project/wxpython/wxPython/$PKG_VERSION/wxwidgets2.8_$PKG_VERSION.orig.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 setuptools:host libpng libjpeg-turbo gtk+ pango gstreamer"
PKG_SECTION="service/system"
PKG_AUTORECONF="no"

#pre_configure_target() {
#  strip_gold
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld"
