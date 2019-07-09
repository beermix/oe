# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libxcb"
PKG_VERSION="1.13.1"
PKG_SHA256="a89fb7af7a11f43d2ce84a844a4b38df688c092bf4b67683aef179cdf2a647c4"
PKG_LICENSE="OSS"
PKG_SITE="http://xcb.freedesktop.org"
PKG_URL="http://xcb.freedesktop.org/dist/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros Python2:host xcb-proto libXau"
PKG_LONGDESC="X C-language Bindings library."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-screensaver \
                           --disable-xprint \
                           --disable-selinux \
                           --disable-xvmc \
                           --enable-xinput \
                           --enable-xkb"

pre_configure_target() {
  PYTHON_LIBDIR=$SYSROOT_PREFIX/usr/lib/$PKG_PYTHON_VERSION
  PYTHON_TOOLCHAIN_PATH=$PYTHON_LIBDIR/site-packages

  PKG_CONFIG="$PKG_CONFIG --define-variable=pythondir=$PYTHON_TOOLCHAIN_PATH"
  PKG_CONFIG="$PKG_CONFIG --define-variable=xcbincludedir=$SYSROOT_PREFIX/usr/share/xcb"
}
