################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="certifi"
PKG_VERSION="2018.01.18"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_URL="https://github.com/certifi/python-certifi/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SOURCE_DIR="python-certifi-$PKG_VERSION*"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="Python module for character encoding auto-detection"
PKG_LONGDESC="Python module for character encoding auto-detection."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
  rm -fR $INSTALL/usr/bin
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
