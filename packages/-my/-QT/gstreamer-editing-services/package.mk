################################################################################
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="gstreamer-editing-services"
PKG_VERSION="1.12.3"
PKG_SITE="http://gstreamer.freedesktop.org/gstreamer"
PKG_URL="https://gstreamer.freedesktop.org/src/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gstreamer"
PKG_SECTION="lib"




PKG_CONFIGURE_OPTS_TARGET="--disable-examples \
			      --disable-tests \
			      --disable-failing-tests \
			      --disable-loadsave \
			      --enable-static \
			      --with-pic \
			      --disable-shared"
