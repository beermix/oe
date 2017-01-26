################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014-2015 vpeter
#      Copyright (C) 2014 streppuiu
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

PKG_NAME="httpd"
PKG_VERSION="2.4.23"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/server/apache.html"
PKG_URL="http://archive.apache.org/dist/httpd/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libressl pcre"
PKG_SECTION="web"
PKG_SHORTDESC="The Apache web server."
PKG_LONGDESC="The Apache web server."
PKG_MAINTAINER="vpeter"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# If you still desire to serve pages as root
APACHE_RUN_AS_ROOT=


configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto


  if [ "$APACHE_RUN_AS_ROOT" == "yes" ]; then
    export CFLAGS="$CFLAGS -DBIG_SECURITY_HOLE"
  fi

  APR_DIR_TARGET="$(get_pkg_build apr)/.install_dev"
  APR_UTIL_DIR_TARGET="$(get_pkg_build apr-util)/.install_dev"

  export CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -lpthread -ldl -expat"

if [ "$TARGET_ARCH" = x86_64 ]; then
	SIZEOF_SIZES="ac_cv_sizeof_struct_iovec=16"
else
	SIZEOF_SIZES="ac_cv_sizeof_struct_iovec=8"
fi

  PKG_CONFIGURE_OPTS_TARGET="CC_FOR_BUILD=$CC \
                             apr_cv_process_shared_works=no \
                             ap_cv_void_ptr_lt_long=no \
                             apr_cv_tcp_nodelay_with_cork=no
                             ac_cv_func_setpgrp_void=yes \
                             ac_cv_file__dev_zero=yes \
                             cross_compiling=yes \
                             $SIZEOF_SIZES \
                             --with-pcre=$SYSROOT_PREFIX/usr \
                             --with-apr=$APR_DIR_TARGET/usr/bin/apr-1-config \
                             --with-apr-util=$APR_UTIL_DIR_TARGET/usr/bin/apu-1-config"

  $PKG_CONFIGURE_SCRIPT $TARGET_CONFIGURE_OPTS $PKG_CONFIGURE_OPTS_TARGET
}

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$ROOT/$PKG_BUILD/.install_dev
  make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  #$STRIP $(find $INSTALL_DEV -name "*.so" 2>/dev/null) 2>/dev/null || :
 # $STRIP $(find $INSTALL_DEV -name "*.so.[0-9]*" 2>/dev/null) 2>/dev/null || :

  #for i in $(find $INSTALL_DEV/usr/lib -name "*.la" 2>/dev/null); do
 #   $SED "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i   #'
 # done

  $SED -i "s|my \$installbuilddir = \"|my \$installbuilddir = \"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apxs
}
