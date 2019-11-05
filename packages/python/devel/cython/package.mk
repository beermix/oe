PKG_NAME="cython"
PKG_VERSION="0.29.14"
PKG_SHA256="6a3370fda27c020c172805c6257f222624bdd5f73653bb93f4af4e9f282d17f7"
PKG_LICENSE="ASL"
PKG_SITE="https://github.com/cython/cython/releases"
PKG_URL="https://github.com/cython/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain distutilscross:host"
PKG_LONGDESC="The Cython compiler for writing C extensions for the Python language"

make_host() {
  unset _python_exec_prefix _python_prefix _python_sysroot
  mkdir -p .$HOST_NAME
  cp -PR * .$HOST_NAME
  cd .$HOST_NAME
  export LDSHARED="$CC -shared"
  python setup.py build
}

makeinstall_host() {
  python setup.py install --prefix="$TOOLCHAIN"
}
