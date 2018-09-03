# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) elfutils

PKG_NAME="glib"
PKG_VERSION="2.58.0"
PKG_SHA256="c0f4ce0730b4f95c47b711613b5406a887c2ee13ea6d25930d72a4fa7fdb77f6"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/glib/?C=M;O=D"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi pcre Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."
PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_HOST="-Dselinux=false \
			-Dlibmount=false \
			-Dinternal_pcre=true \
			-Dxattr=false \
			-Dman=false \
			-Ddtrace=false \
			-Dinstalled_tests=false \
			-Dforce_posix_threads=true \
			-Ddefault_library=static \
			-Dgtk_doc=false"

PKG_MESON_OPTS_TARGET="-Dselinux=false \
			  -Dlibmount=false \
			  -Dinternal_pcre=true \
			  -Dxattr=false \
			  -Dman=false \
			  -Ddtrace=false \
			  -Dsystemtap=false \
			  -Dbsymbolic_functions=true \
			  -Dforce_posix_threads=true \
			  -Dinstalled_tests=false \
			  -Ddefault_library=shared \
			  -Dgtk_doc=false"

#pre_configure_target() {
#   export LDFLAGS="$LDFLAGS -latomic -lm -ldl -lz"
#}

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
