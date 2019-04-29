PKG_NAME="M2Crypto"
PKG_VERSION="0.25.1"
PKG_SITE="https://pypi.python.org/pypi/M2Crypto"
PKG_URL="https://pypi.python.org/packages/9c/58/7e8d8c04995a422c3744929721941c400af0a2a8b8633f129d92f313cfb8/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_SECTION="xmedia/torrent"
PKG_IS_ADDON="no"


make_target() {
  python setup.py build build_ext --openssl=$LIB_PREFIX
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext --openssl=$LIB_PREFIX
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
