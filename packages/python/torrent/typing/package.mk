################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="typing"
PKG_VERSION="3.6.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://pypi.python.org/pypi/typing"
PKG_URL="https://pypi.python.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="Typing – Type Hints for Python"
PKG_LONGDESC="Typing defines a standard notation for Python function and variable type annotations."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDSHARED="$CC -shared"
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
