PKG_NAME="pygame"
PKG_VERSION="1.9.3"
PKG_SITE="https://pypi.python.org/pypi/numpy/#downloads"
PKG_URL="https://pypi.python.org/packages/61/06/3c25051549c252cc6fde01c8aeae90b96831370884504fe428a623316def/pygame-1.9.3.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host Cython"
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
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}