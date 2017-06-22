PKG_NAME="wxPython"
PKG_VERSION="src-3.0.2.0"
PKG_URL="https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain wxWidgets"
PKG_SECTION="system"
PKG_AUTORECONF="no"

#post_unpack() {
#  cp -r $PKG_BUILD/wxPython/* $PKG_BUILD/
#}

make_target() {
  python setup.py WXPORT=gtk2 UNICODE=1 build --cross-compile
}

makeinstall_target() {
  python setup.py WXPORT=gtk2 UNICODE=1 install --root=$INSTALL --prefix=/usr
}