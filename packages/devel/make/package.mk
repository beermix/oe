# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="make"
PKG_VERSION="4.2.1"
PKG_SHA256="d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/make/"
PKG_URL="http://ftpmirror.gnu.org/make/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_LONGDESC="Utility to maintain groups of programs."

pre_configure_host() {
  export CC=$LOCAL_CC
}

post_makeinstall_host() {
  #mkdir -p $TOOLCHAIN/bin
  #cp /home/user/.bin/make $TOOLCHAIN/bin/gmake

  ln -sf make $TOOLCHAIN/bin/gmake

 #ln -sf /bin/make $TOOLCHAIN/bin/make

 #cp -r $PKG_DIR/src/bin/help2man $TOOLCHAIN/bin/

 #mkdir -p $TOOLCHAIN/share/aclocal

 #cp -r $PKG_DIR/src/bin/* $TOOLCHAIN/bin/
 #cp -r -i $PKG_DIR/src/m4/* $TOOLCHAIN/share/aclocal/

 #mkdir -p $TOOLCHAIN/share/include
 #cp -r -i $PKG_DIR/include/* $TOOLCHAIN/share/include
}
