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
PKG_VERSION="2.54.2"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/glib/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libffi libiconv pcre Python2:host util-linux"
PKG_DEPENDS_HOST="libffi:host"
PKG_SECTION="devel"
PKG_SHORTDESC="glib: C support library"
PKG_LONGDESC="GLib is a library which includes support routines for C such as lists, trees, hashes, memory allocation, and many other things."
PKG_AUTORECONF="yes"
PKG_USE_MESON="no"

PKG_MESON_OPTS_TARGET="-Dwith-docs=no -Dwith-man=no -Dwith-pcre=system -Denable-libmount=yes -Denable-dtrace=false"
 
PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-libmount --with-pic --with-pcre=internal"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_snprintf_c99=yes \
                           ac_cv_func_vsnprintf_c99=yes \
                           glib_cv_stack_grows=no \
                           glib_cv_uscore=no \
                           glib_cv_va_val_copy=no \
                           ac_cv_func_posix_getpwuid_r=yes \
                           ac_cv_func_strtod=yes \
                           ac_fsusage_space=yes \
                           fu_cv_sys_stat_statfs2_bsize=yes \
                           ac_cv_func_closedir_void=no \
                           ac_cv_func_getloadavg=no \
                           ac_cv_lib_util_getloadavg=no \
                           ac_cv_lib_getloadavg_getloadavg=no \
                           ac_cv_func_getgroups=yes \
                           ac_cv_func_getgroups_works=yes \
                           ac_cv_func_chown_works=yes \
                           ac_cv_have_decl_euidaccess=no \
                           ac_cv_func_euidaccess=no \
                           ac_cv_have_decl_strnlen=yes \
                           ac_cv_func_strnlen_working=yes \
                           ac_cv_func_lstat_dereferences_slashed_symlink=yes \
                           ac_cv_func_lstat_empty_string_bug=no \
                           ac_cv_func_stat_empty_string_bug=no \
                           vb_cv_func_rename_trailing_slash_bug=no \
                           ac_cv_have_decl_nanosleep=yes \
                           jm_cv_func_nanosleep_works=yes \
                           gl_cv_func_working_utimes=yes \
                           ac_cv_func_utime_null=yes \
                           ac_cv_have_decl_strerror_r=yes \
                           ac_cv_func_strerror_r_char_p=no \
                           jm_cv_func_svid_putenv=yes \
                           ac_cv_func_getcwd_null=yes \
                           ac_cv_func_getdelim=yes \
                           ac_cv_func_mkstemp=yes \
                           utils_cv_func_mkstemp_limitations=no \
                           utils_cv_func_mkdir_trailing_slash_bug=no \
                           jm_cv_func_gettimeofday_clobber=no \
                           gl_cv_func_working_readdir=yes \
                           jm_ac_cv_func_link_follows_symlink=no \
                           utils_cv_localtime_cache=no \
                           ac_cv_struct_st_mtim_nsec=no \
                           gl_cv_func_tzset_clobber=no \
                           gl_cv_func_getcwd_null=yes \
                           gl_cv_func_getcwd_path_max=yes \
                           ac_cv_func_fnmatch_gnu=yes \
                           am_getline_needs_run_time_check=no \
                           am_cv_func_working_getline=yes \
                           gl_cv_func_mkdir_trailing_slash_bug=no \
                           gl_cv_func_mkstemp_limitations=no \
                           ac_cv_func_working_mktime=yes \
                           jm_cv_func_working_re_compile_pattern=yes \
                           ac_use_included_regex=no \
                           gl_cv_c_restrict=no \
                           ac_cv_path_GLIB_GENMARSHAL=$TOOLCHAIN/bin/glib-genmarshal \
                           ac_cv_prog_F77=no \
                           ac_cv_func_posix_getgrgid_r=no \
                           glib_cv_long_long_format=ll \
                           ac_cv_func_printf_unix98=yes \
                           ac_cv_func_newlocale=no \
                           ac_cv_func_uselocale=no \
                           ac_cv_func_strtod_l=no \
                           ac_cv_func_strtoll_l=no \
                           ac_cv_func_strtoull_l=no \
                           gt_cv_c_wchar_t=yes \
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
                           --with-pcre=system \
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
