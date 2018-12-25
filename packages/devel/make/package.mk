# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="make"
PKG_VERSION="4.2.1"
PKG_SHA256="d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/make/"
PKG_URL="http://ftpmirror.gnu.org/make/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""

export CC=$LOCAL_CC

export CFLAGS="-march=native -O2 -fstack-protector-strong"
export LDFLAGS="-Wl,-z,relro -Wl,-z,now"

PKG_CONFIGURE_OPTS_HOST="--without-guile"

post_makeinstall_host() {
  ln -sf make $TOOLCHAIN/bin/gmak
  strip $TOOLCHAIN/bin/make

 #mkdir -p $TOOLCHAIN/bin
 #ln -sf /bin/make $TOOLCHAIN/bin/gmake
 #ln -sf /bin/make $TOOLCHAIN/bin/make

 #cp -r $PKG_DIR/src/bin/help2man $TOOLCHAIN/bin/

#  mkdir -p $TOOLCHAIN/share/aclocal

#  cp -r $PKG_DIR/src/bin/* $TOOLCHAIN/bin/
#  cp -r -i $PKG_DIR/src/m4/* $TOOLCHAIN/share/aclocal/

#  mkdir -p $TOOLCHAIN/share/include
#  cp -r -i $PKG_DIR/include/* $TOOLCHAIN/share/include
}
