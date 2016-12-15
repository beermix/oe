################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="greenlet"
PKG_VERSION="0.4.10"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/greenlet"
PKG_URL="https://pypi.python.org/packages/f2/3f/09412b656067f280cf017ce5b6465e6339089129212425111117be5557d9/greenlet-0.4.10.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="Lightweight in-process concurrent programming"
PKG_LONGDESC="Lightweight in-process concurrent programming."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  export ac_python_version="$PYTHON_VERSION"

  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
  export CFLAGS="$CFLAGS $PYTHON_CPPFLAGS $PYTHON_LDFLAGS"
}

make_target() {
  python setup.py build
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
