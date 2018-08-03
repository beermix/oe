# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="fluxbox"
PKG_VERSION="248b15c"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/fluxbox/fluxbox"
PKG_URL="https://github.com/fluxbox/fluxbox/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libX11 libXrandr libXext libXrender"
PKG_SECTION="x11/other"
PKG_SHORTDESC="Fluxbox is a windowmanager for X that was based on the Blackbox 0.61.1 code"
PKG_LONGDESC="Fluxbox is a windowmanager for X that was based on the Blackbox 0.61.1 code. It is very light on resources and easy to handle but yet full of features to make an easy, and extremely fast, desktop experience. It is built using C++ and licensed under the MIT-License."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --disable-toolbar \
                           --disable-slit \
                           --disable-systray \
                           --enable-ewmh \
                           --disable-xpm \
                           --disable-xft \
                           --disable-fribidi \
                           --disable-debug \
                           --disable-test \
                           --disable-nls \
                           --disable-imlib2 \
                           --enable-silent-rules"

post_install() {
  enable_service windowmanager.service
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/fbrun
  rm -rf $INSTALL/usr/bin/fbsetbg
  rm -rf $INSTALL/usr/bin/fluxbox-generate_menu
  rm -rf $INSTALL/usr/bin/fluxbox-remote
  rm -rf $INSTALL/usr/bin/startfluxbox

  rm -rf $INSTALL/usr/share/fluxbox/styles

  cp $PKG_DIR/config/apps $INSTALL/usr/share/fluxbox/
  cp $PKG_DIR/config/init $INSTALL/usr/share/fluxbox/
  cp $PKG_DIR/config/keys $INSTALL/usr/share/fluxbox/
}
