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

PKG_NAME="vdr-dummydevice"
PKG_VERSION="2.0.0"
PKG_SITE="http://www.vdr-wiki.de/wiki/index.php/Dummydevice-plugin"
PKG_URL="http://phivdr.dyndns.org/vdr/vdr-dummydevice/$PKG_NAME-$PKG_VERSION.tgz"
PKG_SOURCE_DIR="dummydevice-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain vdr"

PKG_SECTION="multimedia"
PKG_SHORTDESC="vdr dummydevice plugin"
PKG_LONGDESC="vdr dummydevice plugin"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  VDR_DIR=$(get_pkg_build vdr)
  export PKG_CONFIG_PATH=$VDR_DIR:$PKG_CONFIG_PATH
  export CPLUS_INCLUDE_PATH=$VDR_DIR/include

  make \
    LIBDIR="." \
    LOCDIR="./locale" \
    all install-i18n
}

post_make_target() {
  VDR_DIR=$(get_pkg_build vdr)
  VDR_APIVERSION=`sed -ne '/define APIVERSION/s/^.*"\(.*\)".*$/\1/p' $VDR_DIR/config.h`
  LIB_NAME=lib${PKG_NAME}

  cp --remove-destination ${LIB_NAME}.so ${LIB_NAME}.so.${VDR_APIVERSION}
  $STRIP libvdr-*.so*
}

makeinstall_target() {
  : # installation not needed, done by create-addon script
}
