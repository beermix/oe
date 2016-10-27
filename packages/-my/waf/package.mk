PKG_NAME="waf"
PKG_VERSION="cfb97d6"
PKG_URL="https://github.com/waf-project/waf/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python:host boost"
PKG_DEPENDS_HOST="toolchain Python:host boost"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="no"


configure_host() {
  cd $ROOT/$PKG_BUILD
  export LIBS="-ltermcap"
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  ./configure --prefix=$HOST _NAME--prefix=/usr --color=yes -v --make-waf --nostrip --nopyc
}



make_host() {
  cd $ROOT/$PKG_BUILD
  MAKEFLAGS=-j1
  waf build
  waf install
}