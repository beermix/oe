# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) --with-data-packaging=archive \

PKG_NAME="icu"
PKG_VERSION="64.2"
PKG_SHA256="627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
#PKG_BUILD_FLAGS="+pic:host +pic"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  export LIBS="-latomic"
}

PKG_CONFIGURE_OPTS_HOST="--enable-static \
                         --disable-shared \
                         $PKG_ICU_OPTS"

configure_package() {
  PKG_CONFIGURE_OPTS_TARGET="--with-cross-build=$PKG_BUILD/.$HOST_NAME \
                             $PKG_ICU_OPTS"

  PKG_CONFIGURE_SCRIPT="${PKG_BUILD}/source/configure"
}

makeinstall_host() {
 : # nothing todo
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/usr/lib/icu
}