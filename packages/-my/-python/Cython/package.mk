PKG_NAME="Cython"
PKG_VERSION="0.25.2"
PKG_SITE="https://pypi.python.org/pypi/Cython"
PKG_URL="https://pypi.python.org/packages/b7/67/7e2a817f9e9c773ee3995c1.15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host greenlet"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="gevent is a coroutine-based Python networking library"
PKG_LONGDESC="gevent is a coroutine-based Python networking library."




make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
