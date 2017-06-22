PKG_NAME="PySocks"
PKG_VERSION="1f898ba"
PKG_GIT_URL="https://github.com/Anorov/PySocks"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
}