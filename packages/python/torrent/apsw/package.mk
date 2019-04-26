PKG_NAME="apsw"
PKG_VERSION="3.27.2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rogerbinns/apsw/releases"
#PKG_URL="https://github.com/rogerbinns/apsw/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/rogerbinns/apsw/releases/download/$PKG_VERSION-r1/apsw-$PKG_VERSION-r1.zip"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host expat sqlite"
PKG_SHORTDESC="Mako: A super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_LONGDESC="Mako is a super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
}

make_target() {
  python2 setup.py build --compiler=unix
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

