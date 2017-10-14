PKG_NAME="scons"
PKG_VERSION="2.5.0"
PKG_SITE="http://www.scons.org/"
PKG_URL="$SOURCEFORGE_SRC/scons/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host"

PKG_SECTION="python/devel"
PKG_SHORTDESC="SCons: an Open Source software construction tool—that is, a next-generation build tool."
PKG_LONGDESC="SCons is an Open Source software construction tool—that is, a next-generation build tool."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
 : # nothing todo
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
