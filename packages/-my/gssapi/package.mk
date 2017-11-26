PKG_NAME="gssapi"
PKG_VERSION="1.2.0"
PKG_URL="https://pypi.python.org/packages/d3/ef/6f659d93575a387910edcc0574445f8edfa3e926e6312b39b947c2923d64/gssapi-1.2.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"

PKG_SECTION="python/system"





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
