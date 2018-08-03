# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="glib"
PKG_VERSION="2.56.1"
PKG_SHA256="40ef3f44f2c651c7a31aedee44259809b6f03d3d20be44545cd7d177221c0b8d"
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

PKG_CONFIGURE_OPTS_HOST="--with-pcre=internal \
                         --enable-static \
                         --disable-shared \
                         --disable-libmount \
                         --with-python=python \
                         --disable-gtk-doc \
                         --disable-gtk-doc-html \
                         --disable-man \
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
      
  ln -sf $SYSROOT_PREFIX/usr/bin/gio-querymodules $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/glib-compile-resources $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/glib-compile-schemas $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/glib-genmarshal $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/glib-gettextize $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/glib-mkenums $BUILD/toolchain/bin/
  ln -sf $SYSROOT_PREFIX/usr/bin/gdbus-codegen $BUILD/toolchain/bin/
}
