# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2010-2011 Roman Weber (roman@openelec.tv)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="attr"
PKG_VERSION="2.4.48"
PKG_SHA256="5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="https://mirrors.up.pt/pub/nongnu/attr/attr-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Extended Attributes Of Filesystem Objects."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="OPTIMIZER= \
                           CONFIG_SHELL=/bin/bash \
                           INSTALL_USER=root INSTALL_GROUP=root \
                           --disable-shared --enable-static"

if build_with_debug; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET DEBUG=-DDEBUG"
else
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET DEBUG=-DNDEBUG"
fi

pre_configure_target() {
# attr fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/
    cp .libs/libattr.a $SYSROOT_PREFIX/usr/lib/

  mkdir -p $SYSROOT_PREFIX/usr/include/attr
    cp include/*.h $SYSROOT_PREFIX/usr/include/attr
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  cp attr $INSTALL/usr/bin/
  cp setfattr $INSTALL/usr/bin/
  cp getfattr $INSTALL/usr/bin/
}
