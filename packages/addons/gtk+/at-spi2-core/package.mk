################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="at-spi2-core"
PKG_VERSION="2.26.2"
PKG_SHA256="c80e0cdf5e3d713400315b63c7deffa561032a6c37289211d8afcfaa267c2615"
PKG_ARCH="any"
PKG_LICENSE="LGPL-2.1"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/at-spi2-core/?C=M;O=D"
PKG_URL="https://download.gnome.org/sources/$PKG_NAME/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libXtst dbus glib glib:host"
PKG_SECTION="accessibility"
PKG_SHORTDESC="D-Bus AT-SPI Core"
PKG_LONGDESC="AT-SPI technologies are currently migrating to D-Bus for their transport technology. As such, this document serves as a tutorial, design document and project update page for the AT-SPI D-Bus project."
PKG_TOOLCHAIN="configure"