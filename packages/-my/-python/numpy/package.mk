PKG_NAME="numpy"
PKG_VERSION="1.13.0"
PKG_SITE="https://pypi.python.org/pypi/numpy/#downloads"
PKG_URL="https://pypi.python.org/packages/05/84/0feb999c05f252af50a5fbc463268044feda92cdaad8cb0d0a6073d76057/numpy-1.13.0.zip"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host cython"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build 
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}
