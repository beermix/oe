PKG_NAME="gevent"
PKG_VERSION="1.1.2"
PKG_SITE="https://pypi.python.org/pypi/gevent"
PKG_URL="https://pypi.python.org/packages/43/8f/cb3224a0e6ab663547f45c10d0651cfd52633fde4283bf68d627084df8cc/gevent-1.1.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host greenlet libev"
PKG_SHORTDESC="gevent is a coroutine-based Python networking library"
PKG_LONGDESC="gevent is a coroutine-based Python networking library."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' $ROOT/$PKG_BUILD/libev/configure
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' $ROOT/$PKG_BUILD/c-ares/configure
}

make_target() {
  python setup.py build 
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
