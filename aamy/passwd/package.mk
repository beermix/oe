################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
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

PKG_NAME="passwd"
PKG_VERSION="0.79"
PKG_SITE="http://shadowsocks.org"
PKG_URL="https://copy.com/Vq7oa4NS9hj1/passwd-0.79.tar.bz2"
PKG_DEPENDS_TARGET="toolchain Python sqlite ncurses"

PKG_SECTION="my"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  autoreconf -i
}

TARGET_CONFIGURE_OPTS="--prefix=/"
