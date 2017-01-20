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

PKG_NAME="libiconv"
PKG_VERSION="1.14"
PKG_SITE="https://www.gnu.org/software/libiconv/"
PKG_URL="http://ftp.gnu.org/pub/gnu/libiconv/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="security"
PKG_SHORTDESC="libiconv library"
PKG_LONGDESC="libiconv library"
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

  PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                             --disable-shared"

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$ROOT/$PKG_BUILD/.install_dev
	make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  for i in $(find $INSTALL_DEV/usr/lib/ -name "*.la" 2>/dev/null); do
    $SED "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i
  done
}
