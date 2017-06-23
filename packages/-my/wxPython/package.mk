PKG_NAME="wxPython"
PKG_VERSION="f244d9d"
PKG_GIT_URL="https://github.com/wxWidgets/wxPython"
PKG_DEPENDS_TARGET="toolchain gtk+"
PKG_SECTION="system"
PKG_AUTORECONF="no"

make_target() {
  python build-wxpython.py build --release
}

makeinstall_target() {
  python build-wxpython.py install --wxpy_installdir=$INSTALL --prefix=/usr
}