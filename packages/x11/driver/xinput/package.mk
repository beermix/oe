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

PKG_NAME="xinput"
PKG_VERSION="1.6.2"
PKG_SITE="http://www.freedesktop.org/wiki/Software/libinput/"
PKG_URL="https://xorg.freedesktop.org/archive/individual/app/xinput-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libinput"
PKG_SECTION="x11/driver"
PKG_SHORTDESC="This is an X driver based on libinput."
PKG_LONGDESC="This is an X driver based on libinput."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

