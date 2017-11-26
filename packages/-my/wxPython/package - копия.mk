PKG_NAME="wxPython"
PKG_VERSION="src-3.0.2.0"
PKG_URL="https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain gtk+"
PKG_SECTION="system"


pre_configure_target() {
# makemkv fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME
}

configure_target() {
  ./configure --host=$TARGET_NAME \
  		--build=$HOST_NAME \
  		--prefix=/usr \
  		--libdir=/usr/lib \
  		--with-gtk=2 \
  		--with-opengl \
  		--enable-unicode \
  		--enable-graphics_ctx \
  		--disable-precomp-headers \
  		--with-libpng=sys -\
  		--with-libjpeg=sys \
  		--with-libtiff=sys \
  		..
  		
  		make

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