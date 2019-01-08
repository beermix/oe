# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="chrome"
PKG_VERSION="1.0"
PKG_REV="155-glibc28.900-gcc8"
PKG_LICENSE="Custom"
PKG_SITE="http://www.google.com/chrome"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo \
                    cups gdk-pixbuf gtk3 harfbuzz \
                    libXtst libXcursor libxss nss pango scrnsaverproto unclutter libnotify icu re2 snappy"
PKG_SECTION="browser"
PKG_SHORTDESC="Google Chrome Browser"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chrome"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

make_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin \
           $ADDON_BUILD/$PKG_ADDON_ID/config \
           $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules \
           $ADDON_BUILD/$PKG_ADDON_ID/lib

  # config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config

  # atk
  cp -PL $(get_build_dir atk)/.$TARGET_NAME/atk/libatk-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # cairo
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo-gobject.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir cairo)/.install_pkg/usr/lib/libcairo.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/libgdk_pixbuf-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gdk-pixbuf modules
  cp -PL $(get_build_dir gdk-pixbuf)/.install_pkg/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/* $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules

  # gtk3 gdk3
  cp -PL $(get_build_dir gtk3)/.$TARGET_NAME/gtk/.libs/libgtk-3.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir gtk3)/.$TARGET_NAME/gdk/.libs/libgdk-3.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # gtk+
  # cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgdk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  # cp -PL $(get_build_dir gtk+)/.install_pkg/usr/lib/libgtk-x11-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # harfbuzz
  cp -PL $(get_build_dir harfbuzz)/.$TARGET_NAME/src/.libs/libharfbuzz.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir harfbuzz)/.$TARGET_NAME/src/.libs/libharfbuzz-icu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libatk-bridge
  cp -PL $(get_build_dir at-spi2-atk)/.$TARGET_NAME/atk-adaptor/libatk-bridge-2.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libatspi
  cp -PL $(get_build_dir at-spi2-core)/.$TARGET_NAME/atspi/libatspi.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libcups
  cp -PL $(get_build_dir cups)/cups/libcups.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # libXcursor
  cp -PL $(get_build_dir libXcursor)/.$TARGET_NAME/src/.libs/libXcursor.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libxss
  cp -PL $(get_build_dir libxss)/.$TARGET_NAME/src/.libs/libXss.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib 

  # libXtst
  cp -PL $(get_build_dir libXtst)/.$TARGET_NAME/src/.libs/libXtst.so.6 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # pango
  cp -PL $(get_build_dir pango)/.$TARGET_NAME/pango/libpangocairo-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.$TARGET_NAME/pango/libpango-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir pango)/.$TARGET_NAME/pango/libpangoft2-1.0.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # unclutter
  cp -P $(get_build_dir unclutter)/.install_pkg/usr/bin/unclutter $ADDON_BUILD/$PKG_ADDON_ID/bin

  # libnotify
  cp -PL $(get_build_dir libnotify)/.install_pkg/usr/lib/libnotify.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # re2
  cp -PL $(get_build_dir re2)/.install_pkg/usr/lib/libre2.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # snappy
  cp -PL $(get_build_dir snappy)/.install_pkg/usr/lib/libsnappy.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib

  # icu
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicuuc.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicudata.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicui18n.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicuio.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicutu.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PL $(get_build_dir icu)/.install_pkg/usr/lib/libicutest.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
}
