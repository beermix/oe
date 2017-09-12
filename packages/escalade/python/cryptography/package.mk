PKG_NAME="cryptography"
PKG_VERSION="2.0.3"
PKG_LICENSE="BSD"
PKG_SITE="https://cryptography.io/"
PKG_GIT_URL="https://github.com/pyca/cryptography"
PKG_DEPENDS_TARGET="toolchain cffi:host Python packaging"
PKG_LONGDESC="A package designed to expose cryptographic primitives and recipes to Python developers"

make_target() {
  export LDSHARED="$CC -shared"
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*.egg-info \
         $INSTALL/usr/lib/python*/site-packages/*/tests
}
