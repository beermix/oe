PKG_NAME="pyxattr"
PKG_VERSION="0.6.0"
PKG_URL="http://pyxattr.k1024.org/downloads/pyxattr-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host attr"
PKG_SECTION="python/system"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LDSHARED="$CC -shared"
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
