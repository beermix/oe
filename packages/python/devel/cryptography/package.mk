PKG_NAME="cryptography"
PKG_VERSION="2.2.2"
PKG_SHA256=""
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/pyca/cryptography/releases"
PKG_URL="https://github.com/pyca/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_PYTHON_DEPENDS_TARGET="asn1crypto cffi enum34 idna ipaddress six"
PKG_LONGDESC="A package designed to expose cryptographic primitives and recipes to Python developers"

pre_configure_target() {
  export CC="$CC -pthread"
}
