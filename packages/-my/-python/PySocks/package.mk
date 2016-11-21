PKG_NAME="PySocks"
PKG_VERSION="7b8f81b"
PKG_GIT_URL="https://github.com/Anorov/PySocks"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
}