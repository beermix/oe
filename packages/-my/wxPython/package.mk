PKG_NAME="wxPython"
PKG_VERSION="src-3.0.2.0"
PKG_URL="https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 setuptools:host libpng libjpeg-turbo gtk+ pango gstreamer"
PKG_SECTION="service/system"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_gold
}


PKG_CONFIGURE_OPTS_TARGET="--with-regex=sys \
			      --with-libpng=sys \
			      --with-libxpm=sys \
			      --with-libjpeg=sys \
			      --with-libtiff=sys \
			      --disable-mediactrl"
