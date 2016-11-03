PKG_NAME="pyxattr"
PKG_VERSION="0.5.5"
PKG_URL="https://pypi.python.org/packages/28/76/175cda88bf4a479c93b686d267f7ca66ac603374fe75219b68245605ac2d/pyxattr-0.5.5.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
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
