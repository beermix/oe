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

PKG_NAME="icu"
PKG_VERSION="61.1"
PKG_SHA256="d007f89ae8a2543a53525c74359b65b36412fa84b3349f1400be6dcf409fafef"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain libiconv icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_BUILD_FLAGS="+pic:host +pic"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  LIBS="-latomic"
}

PKG_CONFIGURE_SCRIPT="source/configure"

PKG_CONFIGURE_OPTS_HOST="--disable-tests --disable-samples"

PKG_CONFIGURE_OPTS_TARGET="--with-cross-build=$PKG_BUILD/.$HOST_NAME --disable-samples --disable-tests"

post_makeinstall_target() {
  rm -f $INSTALL/usr/bin/{derb,genbrk,gencfu,gencnval,gendict,genrb,icuinfo,makeconv,uconv}
  rm -f $INSTALL/usr/sbin/{genccode,gencmn,gennorm2,gensprep,icupkg}
  rm -rf $INSTALL/usr/share/icu
}
