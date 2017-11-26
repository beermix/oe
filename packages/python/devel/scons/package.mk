PKG_NAME="scons"
PKG_VERSION="2.5.1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://scons.org"
PKG_URL="http://downloads.sourceforge.net/sourceforge/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host"
PKG_SECTION="python/devel"
PKG_SHORTDESC="Extensible Python-based build utility"
PKG_LONGDESC="Extensible Python-based build utility"




make_host() {
  :
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
