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
PKG_VERSION="1.8.1"
#PKG_VERSION="b758645"
PKG_URL="http://www.tcpdump.org/release/libpcap-$PKG_VERSION.tar.gz"
#PKG_GIT_URL="https://github.com/the-tcpdump-group/libpcap"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="system interface for user-level packet capture"
PKG_LONGDESC="libpcap (Packet CAPture) provides a portable framework for low-level network monitoring. Applications include network statistics collection, security monitoring, network debugging, etc."
PKG_USE_CMAKE="no"


MAKEFLAGS=-j1

PKG_CONFIGURE_OPTS_TARGET="LIBS=-lpthread \
                           ac_cv_header_libusb_1_0_libusb_h=no \
                           ac_cv_netfilter_can_compile=no \
                           ac_cv_linux_vers=2 \
                           --disable-shared \
                           --with-pcap=linux \
                           --disable-bluetooth \
                           --disable-can \
                           --without-libnl \
                           --disable-dbus \
                           --disable-canusb \
                           --disable-yydebug \
                           --without-septel \
                           --without-dag \
                           --without-snf"

pre_configure_target() {
# When cross-compiling, configure can't set linux version
# forcing it
  sed -i -e 's/ac_cv_linux_vers=unknown/ac_cv_linux_vers=2/' ../configure
  export CFLAGS="$CFLAGS -D_DEFAULT_SOURCE -ffunction-sections -fdata-sections"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
