# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="icu"
PKG_VERSION="61.1"
PKG_SHA256="d007f89ae8a2543a53525c74359b65b36412fa84b3349f1400be6dcf409fafef"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_BUILD_FLAGS="+pic:host +pic"
PKG_TOOLCHAIN="configure"

post_patch() {
  sed -i 's/xlocale/locale/' $PKG_BUILD/source/i18n/digitlst.cpp
}

pre_configure_target() {
  export LIBS="-latomic"
}

#PKG_CONFIGURE_OPTS_HOST="--disable-samples \
#			    --disable-tests \
#			    --disable-extras \
#			    --disable-icuio \
#			    --disable-layout \
#			    --disable-renaming"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-data-packaging=archive \
			      --with-cross-build=$PKG_BUILD/.$HOST_NAME"

PKG_CONFIGURE_SCRIPT="source/configure"

makeinstall_host() {
 : # nothing todo
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/usr/lib/icu
}