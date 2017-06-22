################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="PyAMF"
PKG_VERSION="0.7.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://pypi.python.org/packages/source/P/PyAMF/"
PKG_URL="http://pypi.python.org/packages/source/P/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="PyAMF provides Action Message Format (AMF) support for Python that is compatible with the Adobe Flash Player"
PKG_LONGDESC="PyAMF provides Action Message Format (AMF) support for Python that is compatible with the Adobe Flash Player."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr --optimize=1
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
