PKG_NAME="cffi"
PKG_VERSION="1.5.2"
PKG_SITE="https://www.dlitz.net/software/pycrypto/"
PKG_URL="http://pypi.python.org/packages/source/c/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  export LDSHARED="$CC -shared"
}

make_target() {
  python setup.py build build_ext
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext
}


post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}