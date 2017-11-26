PKG_NAME="rdiff-backup"
PKG_VERSION="1.2.8"
PKG_SITE="http://www.boost.org/"
PKG_URL="http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host libpthread-stubs"

PKG_SECTION="python/system"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}