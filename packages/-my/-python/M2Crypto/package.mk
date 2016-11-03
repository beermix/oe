PKG_NAME="M2Crypto"
PKG_VERSION="0.24.0"
PKG_SITE="https://pypi.python.org/pypi/M2Crypto/"
PKG_URL="https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host openssl"
PKG_PRIORITY="optional"
PKG_SECTION="python/security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_target() {
  python setup.py build build_ext --openssl=$LIB_PREFIX
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext --openssl=$LIB_PREFIX
}


post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}