PKG_NAME="numpy"
PKG_VERSION="1.14.0"
PKG_SITE="https://pypi.python.org/pypi/numpy/#downloads"
PKG_URL="https://pypi.python.org/packages/ee/66/7c2690141c520db08b6a6f852fa768f421b0b50683b7bbcd88ef51f33170/numpy-1.14.0.zip"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host Cython"
PKG_SECTION="python/system"
PKG_TOOLCHAIN="manual"

make_target() {
  python setup.py build 
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}