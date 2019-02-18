PKG_NAME="PyAMF"
PKG_VERSION="0.8.0"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="http://pypi.python.org/packages/source/P/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain distutilscross:host"
PKG_SECTION="python/system"


pre_configure_target() {
  export CFLAGS="-I$TOOLCHAIN/include/python2.7 $CFLAGS"
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
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
