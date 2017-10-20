################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="libpcap"
PKG_VERSION="164dcd9"
#PKG_URL="http://www.tcpdump.org/release/libpcap-$PKG_VERSION.tar.gz"
#PKG_GIT_URL="https://github.com/the-tcpdump-group/libpcap"
PKG_URL="https://github.com/the-tcpdump-group/libpcap/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="system interface for user-level packet capture"
PKG_LONGDESC="libpcap (Packet CAPture) provides a portable framework for low-level network monitoring. Applications include network statistics collection, security monitoring, network debugging, etc."
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"
PKG_USE_NINJA="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DINET6=0 \
			  -DBUILD_WITH_LIBNL=0 \
			  -DBUILD_SHARED_LIBS=0 \
			  -DENABLE_REMOTE=0"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
