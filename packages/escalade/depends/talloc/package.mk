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

PKG_NAME="talloc"
PKG_VERSION="2.1.10"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL3"
PKG_SITE="http://talloc.samba.org"
PKG_URL="http://samba.org/ftp/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Hierarchical pool based memory allocator with destructors"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS="--prefix=/usr \
		   --sysconfdir=/etc/samba \
		   --localstatedir=/var \
		   --bundled-libraries=NONE \
		   --builtin-libraries=replace \
		   --enable-talloc-compat1"


pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./configure $PKG_CONFIGURE_OPTS
}
