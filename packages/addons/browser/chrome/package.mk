################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="chrome"
PKG_VERSION="1.0"
PKG_REV="121"
PKG_ARCH="x86_64"
PKG_LICENSE="Custom"
PKG_SITE="http://www.google.com/chrome"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo chrome-libXcomposite \
                    chrome-libXdamage chrome-libXfixes chrome-libXi chrome-libXrender \
                    chrome-libXtst chrome-libxcb cups gdk-pixbuf gtk3 harfbuzz \
                    libXcursor libxss nss pango scrnsaverproto unclutter"
PKG_SECTION="browser"
PKG_SHORTDESC="Google Chrome Browser"
PKG_LONGDESC="Google Chrome Browser"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Chrome"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES="executable"

make_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin \
           $ADDON_BUILD/$PKG_ADDON_ID/config \
           $ADDON_BUILD/$PKG_ADDON_ID/gdk-pixbuf-modules \
           $ADDON_BUILD/$PKG_ADDON_ID/lib

  # config
  cp -P $PKG_DIR/config/* $ADDON_BUILD/$PKG_ADDON_ID/config
}
