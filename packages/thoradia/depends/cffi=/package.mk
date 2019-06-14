PKG_NAME="cffi"
PKG_VERSION="1.11.5"
PKG_SHA256="e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
PKG_LICENSE="MIT"
PKG_SITE="http://cffi.readthedocs.io/"
PKG_URL="https://files.pythonhosted.org/packages/source/${PKG_NAME:0:1}/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="libffi:host"
PKG_DEPENDS_TARGET="cffi:host libffi"
PKG_LONGDESC="Foreign Function Interface for Python calling C code"

PKG_TOOLCHAIN="python2"

post_makeinstall_target() {
  rm "$INSTALL/usr/lib/$PKG_PYTHON_VERSION"/site-packages/cffi-*.egg/EGG-INFO/requires.txt
}
