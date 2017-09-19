################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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
PKG_VERSION="2.54.0"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi Python:host util-linux"
PKG_DEPENDS_HOST="libffi:host pcre:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_HOST="--enable-static \
                         --disable-shared \
                         --disable-libmount \
                         --disable-selinux \
                         --with-pcre=internal"

PKG_CONFIGURE_OPTS_TARGET="glib_cv_stack_grows=no \
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
                           --with-pcre=internal"

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
  
#  ln -sf $SYSROOT_PREFIX/usr/bin/gapplication $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gdbus $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gio $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gio-querymodules $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/glib-compile-resources $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/glib-compile-schemas $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/glib-genmarshal $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/glib-gettextize $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/glib-mkenums $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gobject-query $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gresource $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gsettings $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gtester $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gtester-report $ROOT/$BUILD/toolchain/bin/
#  ln -sf $SYSROOT_PREFIX/usr/bin/gdbus-codegen $ROOT/$BUILD/toolchain/bin/
}
