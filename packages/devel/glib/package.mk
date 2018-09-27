# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) | gettext:host

PKG_NAME="glib"
PKG_VERSION="2.58.1"
PKG_SHA256="97d6a9d926b6aa3dfaadad3077cfb43eec74432ab455dff14250c769d526d7d6"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://ftp.gnome.org/pub/gnome/sources/glib/?C=M;O=D" # https://github.com/GNOME/glib/tree/glib-2-58
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/GNOME/glib/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libffi pcre Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host pcre:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."
#PKG_TOOLCHAIN="autotools"
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_HOST="-Dselinux=false \
			-Dlibmount=false \
			-Dman=false \
			-Dgtk_doc=false \
			-Dinternal_pcre=false \
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

PKG_CONFIGURE_OPTS_HOST="PCRE_LIBS=-l:libpcre.a \
                         --enable-static \
                         --disable-shared \
                         --disable-libmount \
                         --with-python=python \
                         --with-pic"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_snprintf_c99=yes \
                           ac_cv_func_vsnprintf_c99=yes \
                           glib_cv_stack_grows=no \
                           glib_cv_uscore=no \
                           glib_cv_va_val_copy=no \
                           --disable-selinux \
                           --disable-fam \
                           --enable-xattr \
                           --disable-libelf \
                           --disable-gtk-doc \
                           --disable-gtk-doc-html \
                           --disable-man \
                           --disable-dtrace \
                           --disable-systemtap \
                           --enable-Bsymbolic \
                           --with-gnu-ld \
                           --with-threads=posix \
                           --with-pcre=internal \
                           --with-python=python"

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
