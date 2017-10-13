# Made by github.com/escalade
PKG_NAME="asn1crypto"
PKG_VERSION="b5db1c3"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/wbond/asn1crypto"
PKG_URL="https://github.com/wbond/asn1crypto/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_SECTION="escalade/python"
PKG_SHORTDESC="Python ASN.1 library with a focus on performance and a pythonic API"
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

pre_make_target() {
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
  find $INSTALL/usr/lib/python*/site-packages/  -name "*.py" -exec rm -rf {} ";"
}
