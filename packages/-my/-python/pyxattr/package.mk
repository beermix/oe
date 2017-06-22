PKG_NAME="pyxattr"
PKG_VERSION="7a84956"
PKG_GIT_URL="https://github.com/iustin/pyxattr"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
