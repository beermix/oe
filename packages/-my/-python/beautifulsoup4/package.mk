PKG_NAME="beautifulsoup4"
PKG_VERSION="4.5.1"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="https://www.crummy.com/software/BeautifulSoup/bs4/download/4.5/beautifulsoup4-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"

PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

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
