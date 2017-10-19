################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="M2Crypto"
PKG_VERSION="0.24.0u"
PKG_SITE="https://pypi.python.org/pypi/M2Crypto"
PKG_URL="https://dl.dropboxusercontent.com/s/5szbmcgaobdds6k/M2Crypto-0.24.0u.tar.xz"
PKG_SOURCE_DIR="m2crypto-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="M2Crypto is the most complete Python wrapper for OpenSSL"
PKG_LONGDESC="M2Crypto is the most complete Python wrapper for OpenSSL."

PKG_AUTORECONF="no"

pre_configure_target() {
  export LDSHARED="$CC -shared"
}

make_target() {
  python setup.py build build_ext --openssl=$LIB_PREFIX
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr build_ext --openssl=$LIB_PREFIX
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/$PKG_NAME-*.egg-info
}
