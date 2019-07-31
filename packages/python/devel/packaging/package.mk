PKG_NAME="packaging"
PKG_VERSION="19.1"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/packaging"
PKG_URL="https://pypi.python.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
PKG_DEPENDS_HOST="Python2:host six:host pyparsing:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="packaging: Core utilities for Python packages"
PKG_LONGDESC="Packaging is the Core utilities for Python packages package"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
