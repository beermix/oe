PKG_NAME="apsw"
PKG_VERSION="3.28.0"
PKG_SHA256="9e7204f139b9da4c8e57945b524d85b4ebc07ebbfd894958e68fc142c928c274"
PKG_SITE="https://github.com/rogerbinns/apsw/releases"
#PKG_URL="https://github.com/rogerbinns/apsw/archive/${PKG_VERSION}.tar.gz"
PKG_URL="https://github.com/rogerbinns/apsw/releases/download/$PKG_VERSION-r1/apsw-$PKG_VERSION-r1.zip"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host expat sqlite"
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

