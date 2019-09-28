# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="Pillow"
PKG_VERSION="6.1.0"
PKG_SHA256="0804f77cb1e9b6dbd37601cee11283bba39a8d44b9ddb053400c58e0c0d7d9de"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/python-pillow/Pillow/releases"
PKG_URL="https://files.pythonhosted.org/packages/source/${PKG_NAME:0:1}/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2 distutilscross:host zlib freetype libjpeg-turbo tiff"
PKG_LONGDESC="The Python Imaging Library adds image processing capabilities to your Python interpreter."
PKG_TOOLCHAIN="manual"

pre_make_target() {
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

  rm -rf $INSTALL/usr/bin
}
