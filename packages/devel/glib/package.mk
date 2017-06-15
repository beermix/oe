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
PKG_VERSION="2.52.2"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/2.52/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi util-linux expat pcre Python:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --with-pcre=internal"
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
                           --disable-libelf \
                           --disable-gtk-doc \
                           --disable-man \
                           --disable-dtrace \
                           --disable-systemtap \
                           --enable-Bsymbolic \
                           --with-threads=posix \
                           --with-pcre=system \
                           --enable-static"

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

  mkdir -p $INSTALL/usr/share/libalpm/hooks/
  cp $PKG_DIR/hooks/gio-querymodules.hook $INSTALL/usr/share/libalpm/hooks/
  cp $PKG_DIR/hooks/glib-compile-schemas.hook $INSTALL/usr/share/libalpm/hooks/

  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gapplication $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gdbus $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gdbus-codegen $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gio $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gio-querymodules $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-compile-resources $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-compile-schemas $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-genmarshal $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-gettextize $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-mkenums $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gobject-query $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gresource $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gsettings $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gtester $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gtester-report $ROOT/$BUILD/toolchain/bin/
}
