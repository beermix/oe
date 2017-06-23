PKG_NAME="wxPython"
PKG_VERSION="f244d9d"
PKG_GIT_URL="https://github.com/wxWidgets/wxPython"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}