# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="Mako"
PKG_VERSION="1.0.7"
PKG_SHA256="4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://pypi.org/project/Mako"
PKG_URL="https://files.pythonhosted.org/packages/source/${PKG_NAME:0:1}/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host setuptools:host MarkupSafe:host"
PKG_SECTION="python"
PKG_SHORTDESC="Mako: A super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_LONGDESC="Mako is a super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_TOOLCHAIN="manual"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}


pre_make_target() {
  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
  export LDSHARED="$CC -shared"
  cd .$TARGET_NAME
}

make_target() {
  python setup.py build --cross-compile
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}


post_makeinstall_target() {
  find $INSTALL/usr/lib/python*/site-packages/  -name "*.py" -exec rm -rf {} ";"
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
