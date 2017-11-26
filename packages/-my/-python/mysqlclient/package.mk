PKG_NAME="mysqlclient"
PKG_VERSION="1.3.10"
PKG_SITE="https://pypi.python.org/pypi/mysqlclient/"
PKG_URL="https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host mariadb"
PKG_SECTION="python/system"



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
