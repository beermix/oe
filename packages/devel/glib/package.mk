################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2016-     Team LibreELEC
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

PKG_NAME="glib"
PKG_VERSION="2.54.1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi pcre elfutils libiconv Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host pcre:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."
PKG_AUTORECONF="yes"
PKG_USE_MESON="no"

PKG_MESON_OPTS_TARGET="-Dwith-docs=no -Dwith-man=no -Dwith-pcre=system -Denable-libmount=yes -Denable-dtrace=false"
 
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-libmount --with-pic --with-pcre=internal"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_mmap_fixed_mapped=yes \
                           ac_cv_func_posix_getpwuid_r=yes \
                           ac_cv_func_posix_getgrgid_r=yes \
                           ac_cv_func_printf_unix98=yes \
                           ac_cv_func_snprintf_c99=yes \
                           ac_cv_func_vsnprintf_c99=yes \
                           glib_cv_stack_grows=no \
                           glib_cv_uscore=no \
                           glib_cv_va_val_copy=no \
                           --disable-selinux \
                           --disable-fam \
                           --enable-xattr \
                           --enable-libelf \
                           --disable-gtk-doc \
                           --disable-man \
                           --disable-dtrace \
                           --disable-systemtap \
                           --enable-Bsymbolic \
                           --with-gnu-ld \
                           --with-threads=posix \
                           --with-pcre=system"

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
