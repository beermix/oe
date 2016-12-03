PKG_NAME="numpy"
PKG_VERSION="master"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_GIT_URL="https://github.com/numpy/numpy.git"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_target() {
  python setup.py build_ext --inplace -j 4
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr 
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}