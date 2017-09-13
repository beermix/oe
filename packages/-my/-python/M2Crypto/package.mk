PKG_NAME="M2Crypto"
#PKG_VERSION="0.25.0"
PKG_VERSION="0.24.0"
PKG_GIT_URL="https://gitlab.com/m2crypto/m2crypto"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host openssl swig:host"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build build_ext --openssl=$LIB_PREFIX
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext --openssl=$LIB_PREFIX
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}