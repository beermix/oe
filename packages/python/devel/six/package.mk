PKG_NAME="six"
PKG_VERSION="1.10.0"
PKG_SITE="http://bitbucket.org/lambacck/distutilscross/"
PKG_URL="https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
PKG_DEPENDS_HOST="Python:host setuptools:host"
PKG_SECTION="python/devel"
PKG_SHORTDESC="distutilscross: Cross Compile Python Extensions"
PKG_LONGDESC="distutilscross enhances distutils to support Cross Compile of Python extensions"

makeinstall_host() {
  python setup.py install --prefix=$ROOT/$TOOLCHAIN
}