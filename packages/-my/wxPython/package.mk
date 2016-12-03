PKG_NAME="wxPython"
PKG_VERSION="src-3.0.2.0"
PKG_URL="https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--libdir=/usr/lib \
			     --with-gtk=2 \
			     --with-opengl \
			     --enable-unicode \
			     --enable-graphics_ctx \
			     --enable-mediactrl \
			     --disable-precomp-headers \
			     --with-regex=sys \
			     --with-libpng=sys \
			     --with-libxpm=sys \
			     --with-libjpeg=sys \
			     --with-libtiff=sys"