PKG_NAME="six"
PKG_VERSION="1.12.0"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/six"
PKG_URL="https://pypi.python.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
PKG_DEPENDS_HOST="Python2:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="six: Python 2 and 3 compatibility utilities"
PKG_LONGDESC="Six is a Python 2 and 3 compatibility library. It provides utility functions for smoothing over the differences between the Python versions with the goal of writing Python code that is compatible on both Python versions."
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}

makeinstall_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"

  python setup.py build --cross-compile
  python setup.py install --root=$INSTALL --prefix=/usr

  rm -rf $INSTALL/usr/bin
  find $INSTALL/usr/lib/python*/site-packages/  -name "*.py" -exec rm -rf {} ";"
}