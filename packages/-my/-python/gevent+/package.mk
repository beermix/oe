PKG_NAME="gevent"
PKG_VERSION="1.1.2"
PKG_URL="https://github.com/gevent/gevent/releases/download/v$PKG_VERSION/gevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host greenlet"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="gevent is a coroutine-based Python networking library"
PKG_LONGDESC="gevent is a coroutine-based Python networking library."


pre_configure_target() {
  cd $PKG_BUILD
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' libev/configure
    sed -i -e 's/^cross_compiling=no/cross_compiling=yes/' c-ares/configure
    
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
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
