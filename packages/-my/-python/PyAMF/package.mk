PKG_NAME="PyAMF"
PKG_VERSION="0.8.0"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="http://pypi.python.org/packages/source/P/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="python/system"

PKG_AUTORECONF="no"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
}

make_target() {
  python2 setup.py build --cross-compile
}

makeinstall_target() {
  python2 setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
