PKG_NAME="PySocks"
PKG_VERSION="1.6.7"
PKG_URL="https://github.com/Anorov/PySocks/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
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