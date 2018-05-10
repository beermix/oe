################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="apsw"
PKG_VERSION="3.8.11.1-r1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/rogerbinns/apsw"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/rogerbinns/apsw/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 sqlite distutilscross:host"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="APSW stands for Another Python SQLite Wrapper"
PKG_LONGDESC="APSW stands for Another Python SQLite Wrapper."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
}

make_target() {
  python setup.py build --enable=load_extension
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1 --skip-build
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
