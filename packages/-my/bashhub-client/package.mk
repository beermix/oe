PKG_NAME="bashhub-client"
PKG_VERSION="1.1.0"
PKG_URL="https://github.com/rcaloras/bashhub-client/archive/1.1.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"

PKG_SECTION="python/system"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
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
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
