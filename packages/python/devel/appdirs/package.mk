PKG_NAME="appdirs"
PKG_VERSION="1.4.3"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/appdirs"
PKG_URL="https://pypi.python.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
PKG_DEPENDS_HOST="Python2:host"
PKG_PRIORITY="optional"
PKG_SHORTDESC="appdirs: Python module for determining appropriate platform-specific dirs"
PKG_LONGDESC="appdirs is a small Python module for determining appropriate platform-specific dirs, e.g. a user data dir."
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
