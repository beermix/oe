
################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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
PKG_VERSION="2.50.3"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/2.50/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi attr util-linux expat pcre Python:host"
PKG_DEPENDS_HOST="libffi:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed|-Wl,--no-as-needed|"`
}
                           
PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_mmap_fixed_mapped=yes \
                           ac_cv_func_posix_getpwuid_r=yes \
                           ac_cv_func_posix_getgrgid_r=yes \
                           ac_cv_func_printf_unix98=yes \
                           ac_cv_func_snprintf_c99=yes \
                           ac_cv_func_vsnprintf_c99=yes \
                           --disable-selinux \
                           --disable-fam \
                           --enable-xattr \
                           --disable-libelf \
                           --disable-gtk-doc \
                           --disable-man \
                           --disable-dtrace \
                           --disable-systemtap \
                           --enable-Bsymbolic \
                           --with-gnu-ld \
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

  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gdbus-codegen $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-genmarshal $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-gettextize $ROOT/$BUILD/toolchain/bin/    
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/glib-mkenums $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gobject-query $ROOT/$BUILD/toolchain/bin/  
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gtester $ROOT/$BUILD/toolchain/bin/
  ln -sfv $ROOT/$BUILD/toolchain/x86_64-openelec-linux-gnu/sysroot/usr/bin/gtester-report $ROOT/$BUILD/toolchain/bin/
}
