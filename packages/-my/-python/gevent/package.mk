################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="gevent"
PKG_VERSION="1.1.2"
PKG_SITE="https://pypi.python.org/pypi/gevent"
PKG_URL="https://github.com/gevent/gevent/releases/download/v$PKG_VERSION/gevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host greenlet"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="gevent is a coroutine-based Python networking library"
PKG_LONGDESC="gevent is a coroutine-based Python networking library."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' $ROOT/$PKG_BUILD/libev/configure
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' $ROOT/$PKG_BUILD/c-ares/configure
    strip_hard
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
