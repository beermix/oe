PKG_NAME="pyspotify"
PKG_VERSION="2.0.5"
PKG_URL="https://dl.dropboxusercontent.com/s/8o0t82j8vt5ulnv/pyspotify-2.0.5.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"

PKG_SECTION="python/security"




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