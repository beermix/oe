# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="make"
PKG_VERSION="4.3"
PKG_SHA256="e05fdde47c5f7ca45cb697e973894ff4f5d79e13b750ed57d7b66d8defc78e19"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/make/"
PKG_URL="http://ftpmirror.gnu.org/make/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_LONGDESC="Utility to maintain groups of programs."
#PKG_TOOLCHAIN="manual"

pre_configure_host() {
  export CC=$LOCAL_CC
}

PKG_CONFIGURE_OPTS_TARGET="--disable-nls"

post_makeinstall_host() {
#  mkdir -p $TOOLCHAIN/bin

  ln -sf make $TOOLCHAIN/bin/gmake

#  ln -sf /usr/bin/make $TOOLCHAIN/bin/make

#  cp -r $PKG_DIR/src/bin/* $TOOLCHAIN/bin

# mkdir -p $TOOLCHAIN/share/aclocal

# cp -r $PKG_DIR/src/bin/* $TOOLCHAIN/bin/
# cp -r -i $PKG_DIR/src/m4/* $TOOLCHAIN/share/aclocal/

# mkdir -p $TOOLCHAIN/share/include
# cp -r -i $PKG_DIR/include/* $TOOLCHAIN/share/include
}
