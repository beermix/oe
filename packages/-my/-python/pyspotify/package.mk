PKG_NAME="pyspotify"
PKG_VERSION="2.0.5"
PKG_URL="https://dl.dropboxusercontent.com/s/8o0t82j8vt5ulnv/pyspotify-2.0.5.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"



pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  strip_gold
  rm -rf .$TARGET_NAME
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  export LDSHARED="$CC -shared"
  pip install pyspotify

}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --cross-compile --root=$INSTALL --prefix=/usr 
}


post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}