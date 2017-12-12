################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2015 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="tslib"
PKG_VERSION="1.3-rc1"
PKG_SITE="https://github.com/kergoth/tslib"
PKG_GIT_URL="https://github.com/kergoth/tslib"
PKG_DEPENDS_TARGET="toolchain evtest"

PKG_SECTION="system"
PKG_SHORTDESC="Touchscreen access library"
PKG_LONGDESC="Touchscreen access library"
PKG_MAINTAINER="vpeter"

PKG_TOOLCHAIN="autotools"

STATIC="yes"

DISABLED_MODULES="arctic2 corgi collie h3600 linear_h2200 mk712 cy8mrln_palmpre"
ENABLED_MODULES="linear dejitter variance pthres ucb1x00 tatung input galax dmc touchkit st1232 waveshare"

post_patch() {
  if [ -f $PKG_DIR/ts_uinput_touch.c ]; then
    cp $PKG_DIR/ts_uinput_touch.c $(get_build_dir tslib)/tests
  fi

  if [ -f $PKG_DIR/st1232-raw.c ]; then
    cp $PKG_DIR/st1232-raw.c $(get_build_dir tslib)/plugins
  fi
}

pre_configure_target() {
  if [ "$STATIC" = "yes" ]; then
    OPTS_MODULES="--enable-static --disable-shared"
    for module in $ENABLED_MODULES; do
      OPTS_MODULES="$OPTS_MODULES --enable-$module=static"
    done
  fi

  for module in $DISABLED_MODULES; do
    OPTS_MODULES="$OPTS_MODULES --disable-$module"
  done

  PKG_CONFIGURE_OPTS_TARGET="$OPTS_MODULES \
                             --sysconfdir=/storage/.config/ts"
}

post_makeinstall_target() {
  chmod 644 $PKG_DIR/system.d/*.service

  rm -fr $INSTALL/etc $INSTALL/storage

  mkdir -p $INSTALL/usr/config/ts
  chmod 644 $PKG_DIR/config/*
  cp $PKG_DIR/config/* $INSTALL/usr/config/ts

  mkdir -p $INSTALL/usr/bin
  chmod 755 $PKG_DIR/scripts/*.sh
  cp $PKG_DIR/scripts/*.sh $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/share/kodi/addons
  cp -a $PKG_DIR/addon/* $INSTALL/usr/share/kodi/addons

  mkdir -p $INSTALL/usr/bin
  cp $(get_build_dir evtest)/.$TARGET_NAME/evtest $INSTALL/usr/bin
}

post_install() {
  enable_service ts_uinput_touch.service
}
