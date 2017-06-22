PKG_NAME="wxPython"
PKG_VERSION="wxPy-3.0.2.0"
PKG_GIT_URL="https://github.com/wxWidgets/wxPython"
PKG_DEPENDS_TARGET="toolchain libX11 setuptools:host libpng libjpeg-turbo gtk+ pango numpy"
PKG_SECTION="system"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-gui"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/wx
}