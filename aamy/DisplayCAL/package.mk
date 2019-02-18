PKG_NAME="DisplayCAL"
PKG_VERSION="3.3.1.0"
PKG_SITE="https://sourceforge.net/projects/dispcalgui"
PKG_URL="https://sourceforge.net/projects/dispcalgui/files/release/$PKG_VERSION/DisplayCAL-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXext libXtst libjpeg-turbo wxPython numpy pygame"
PKG_SECTION="system"


make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}



find . -type f -exec sed -i 's/env python2/env python2/' {} \;
  sed -i 's/sys.exit(1)//' Editra-${_editraver}/setup.py
}

build() {
  cd wxPython-src-${pkgver}
  ./configure --prefix=/usr --libdir=/usr/lib --with-gtk=2 --with-opengl --enable-unicode \
    --enable-graphics_ctx --disable-precomp-headers \
    --with-regex=sys --with-libpng=sys --with-libxpm=sys --with-libjpeg=sys --with-libtiff=sys
  cd wxPython
  python2 setup.py WXPORT=gtk2 UNICODE=1 build
}

package() {
  cd wxPython-src-${pkgver}/wxPython
  python2 setup.py WXPORT=gtk2 UNICODE=1 install --root="${pkgdir}"
  install -D -m644 ../docs/licence.txt "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
