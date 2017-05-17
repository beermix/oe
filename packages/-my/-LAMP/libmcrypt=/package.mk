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

PKG_NAME="libmcrypt"
PKG_VERSION="8c26221"
PKG_SITE="http://sourceforge.net/projects/mcrypt/"
PKG_GIT_URL="https://github.com/winlibs/libmcrypt"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_SHORTDESC="crypt library"
PKG_LONGDESC="mcrypt, and the accompanying libmcrypt, are intended to be replacements for the old Unix crypt, except that they are under the GPL and support an ever-wider range of algorithms and modes."
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --enable-static \
                           --disable-shared"
                           
pre_configure_target() {
	# doesn't like to be build in target folder
	cd $ROOT/$PKG_BUILD
	rm -fr .$TARGET_NAME
	chmod +x -R $ROOT/$PKG_BUILD
}

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$ROOT/$PKG_BUILD/.install_dev
	make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  for i in $(find $INSTALL_DEV/usr/lib/ -name "*.la" 2>/dev/null); do
    $SED "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i
  done
}
