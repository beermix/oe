################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="M2Crypto"
PKG_VERSION="0.22.6rc4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/M2Crypto"
PKG_URL="http://pypi.python.org/packages/source/M/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="M2Crypto is the most complete Python wrapper for OpenSSL"
PKG_LONGDESC="M2Crypto is the most complete Python wrapper for OpenSSL."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build --cross-compile build_ext --openssl=$LIB_PREFIX
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext --openssl=$LIB_PREFIX
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}