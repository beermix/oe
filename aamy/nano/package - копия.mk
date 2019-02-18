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

PKG_NAME="nano"
PKG_VERSION="2.7.3"
PKG_SITE="http://www.nano-editor.org/"
PKG_URL="https://www.nano-editor.org/dist/v2.7/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses file sed"
PKG_PRIORITY="optional"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"
PKG_LONGDESC="GNU nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone of the Pico text editor."


PKG_TOOLCHAIN="autotools"
PKG_LOCALE_INSTALL="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
			      --enable-extra \
			      --enable-libmagic \
			      --enable-nls \
			      --enable-color \
			      --infodir=/storage/.config \
			      --sysconfdir=/storage/.config/nano"

post_makeinstall_target() {
  #rm -rf $INSTALL/usr/share/nano
  rm -rf $INSTALL/storage
}
