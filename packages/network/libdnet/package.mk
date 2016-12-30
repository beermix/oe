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

PKG_NAME="libdnet"
PKG_VERSION="54a0c14"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://code.google.com/p/libdnet/"
PKG_GIT_URL="https://github.com/dugsong/libdnet"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="A simplified, portable interface to several low-level networking routines"
PKG_LONGDESC="A simplified, portable interface to several low-level networking routines"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_strlcat=no \
                           ac_cv_func_strlcpy=no \
                           --enable-static \
                           --disable-shared \
                           --without-python"

pre_configure_target() {
  sed "s|@prefix@|$SYSROOT_PREFIX/usr|g" -i $ROOT/$PKG_BUILD/dnet-config.in
}

post_makeinstall_target() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
    cp dnet-config $ROOT/$TOOLCHAIN/bin/
}
