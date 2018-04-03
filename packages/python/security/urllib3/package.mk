################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="urllib3"
PKG_VERSION="1.22"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/shazow/urllib3/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/shazow/urllib3/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host"
PKG_SECTION="xmedia/torrent"
PKG_SHORTDESC="HTTP library with thread-safe connection pooling and file post support"
PKG_LONGDESC="HTTP library with thread-safe connection pooling and file post support."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
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
