PKG_NAME="wxPython"
PKG_VERSION="x999"
#PKG_GIT_URL="https://github.com/wxWidgets/wxPython"
PKG_URL="https://dl.dropboxusercontent.com/s/aq3kif17m2o5yyk/wxpython-x999.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 setuptools:host libpng libjpeg-turbo gtk+ pango gstreamer"
PKG_SECTION="service/system"


#pre_configure_target() {
#  strip_gold
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld"
