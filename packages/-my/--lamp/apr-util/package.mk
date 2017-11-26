################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 ultraman
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

PKG_NAME="apr-util"
PKG_VERSION="1.6.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="Apache License"
PKG_SITE="http://apr.apache.org/"
PKG_URL="http://archive.apache.org/dist/apr/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain apr"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="The Apache Portable Runtime Utility Library."
PKG_LONGDESC="The Apache Portable Runtime Utility Library provides a predictable and consistent interface to underlying client library interfaces."
PKG_MAINTAINER="ultraman"

PKG_USE_CMAKE="no"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  

  
}
  
  PKG_CONFIGURE_OPTS_TARGET="--with-apr=$SYSROOT_PREFIX/usr/bin/apr-1-config \
                             --with-openssl \
                             --with-crypto \
                             --with-openssl=$SYSROOT_PREFIX/usr \
                             --with-sqlite3=$SYSROOT_PREFIX/usr"



make_target() {
  # use this version only for addon (don't install it to a system)
  #INSTALL=$PKG_BUILD/.INSTALL
  make -j1 install DESTDIR=$INSTALL $PKG_MAKEINSTALL_OPTS_TARGET

  $STRIP $(find $INSTALL -name "*.so" 2>/dev/null) 2>/dev/null || :
  $STRIP $(find $INSTALL -name "*.so.[0-9]*" 2>/dev/null) 2>/dev/null || :

  for i in $(find $INSTALL/usr/lib -name "*.la" 2>/dev/null); do
    $SED "s|\(['= ]\)/usr|\\1$INSTALL/usr|g" $i		#'
  done

  $SED -i "s|^prefix=\"|prefix=\"$INSTALL|" $INSTALL/usr/bin/apu-1-config
  $SED -i "s|^bindir=\"|bindir=\"$INSTALL|" $INSTALL/usr/bin/apu-1-config
}
