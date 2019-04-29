PKG_NAME="pyxattr"
PKG_VERSION="0.6.1"
PKG_SHA256="b525843f6b51036198b3b87c4773a5093d6dec57d60c18a1f269dd7059aa16e3"
PKG_URL="http://pyxattr.k1024.org/downloads/pyxattr-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host attr"
PKG_SECTION="python/system"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
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
