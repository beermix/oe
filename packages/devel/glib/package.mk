# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) | gettext:host
# https://github.com/GNOME/glib/tree/glib-2-58

PKG_NAME="glib"
#PKG_VERSION="2.58.1"
#PKG_SHA256="d08b04e22d348c4ca494b016d278f835386e3fd91f294f20204cd50f205e5cfe"
PKG_VERSION="17519e0"
PKG_SHA256="527cdb675eb1d86d057e4d6ed878eb0d0f1b7d6fa672333deab34dd6c2e7bd9c"
PKG_LICENSE="LGPL"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/glib/?C=M;O=D" # https://github.com/GNOME/glib/tree/glib-2-58
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/GNOME/glib/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libffi pcre Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host"
PKG_BUILD_FLAGS="-hardening"

PKG_MESON_OPTS_HOST="-Dselinux=false \
			-Dlibmount=false \
			-Dman=false \
			-Dgtk_doc=false \
			-Dinternal_pcre=true \
			-Dbsymbolic_functions=true \
			-Dforce_posix_threads=true \
			-Ddefault_library=static"

PKG_MESON_OPTS_TARGET="-Dselinux=false \
			  -Dlibmount=false \
			  -Dman=false \
			  -Dgtk_doc=false \
			  -Dinternal_pcre=false \
			  -Dbsymbolic_functions=true \
			  -Dforce_posix_threads=true"

post_makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp g*-2.0.pc $SYSROOT_PREFIX/usr/lib/pkgconfig

  mkdir -p $SYSROOT_PREFIX/usr/share/aclocal
    cp ../m4macros/glib-gettext.m4 $SYSROOT_PREFIX/usr/share/aclocal
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/gdbus-2.0
  rm -rf $INSTALL/usr/lib/glib-2.0
  rm -rf $INSTALL/usr/share
}
