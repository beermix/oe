PKG_NAME="BeautifulSoup"
PKG_VERSION="3.2.1"
PKG_SITE="https://pypi.python.org/pypi/BeautifulSoup/"
PKG_URL="https://pypi.python.org/packages/source/B/BeautifulSoup/BeautifulSoup-3.2.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="python/system"


make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}