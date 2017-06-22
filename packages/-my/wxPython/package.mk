PKG_NAME="wxPython"
PKG_VERSION="src-3.0.2.0"
PKG_URL="https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain wxWidgets"
PKG_SECTION="system"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-gtk=2 \
			      --with-opengl \
			      --enable-unicode \
			      --enable-graphics_ctx \
			      --enable-mediactrl \
			      --enable-webview \
			      --with-regex=builtin \
			      --with-libpng \
			      --with-libjpeg \
			      --with-libtiff \
			      --disable-precomp-headers"

make_target() {
  make
  cd ../wxPython
  python setup.py WXPORT=gtk2 UNICODE=1 build --cross-compile
}

makeinstall_target() {
  make install
  cd ../wxPython
  python setup.py WXPORT=gtk2 UNICODE=1 install --root=$INSTALL --prefix=/usr
}