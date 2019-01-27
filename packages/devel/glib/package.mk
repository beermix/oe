# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) | gettext:host
# https://github.com/GNOME/glib/tree/glib-2-58

PKG_NAME="glib"
PKG_VERSION="2.59.1"
PKG_SHA256="42d624d1e24cfb173002adfed48c123f5541cb86c4624a3f03500c7026a3f1cd"
PKG_LICENSE="LGPL"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/glib/?C=M;O=D" # https://github.com/GNOME/glib/tree/glib-2-58
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/GNOME/glib/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libffi pcre Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host"

PKG_MESON_OPTS_HOST="-Dselinux=disabled \
			-Dlibmount=false \
			-Dman=false \
			-Dgtk_doc=false \
			-Dinternal_pcre=true \
			-Dbsymbolic_functions=true \
			-Dforce_posix_threads=true \
			-Dinstalled_tests=false \
			-Ddefault_library=static"

PKG_MESON_OPTS_TARGET="-Dselinux=disabled \
			  -Dlibmount=false \
			  -Dman=false \
			  -Dgtk_doc=false \
			  -Dinternal_pcre=false \
			  -Dbsymbolic_functions=true \
			  -Dforce_posix_threads=true \
			  -Dinstalled_tests=false \
			  -Diconv=libc"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#  export CXXFLAGS="$CXXFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto=4 -fno-math-errno -fno-semantic-interposition -fno-trapping-math"
#}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/gdbus-2.0
  rm -rf $INSTALL/usr/lib/glib-2.0
  rm -rf $INSTALL/usr/share
}
