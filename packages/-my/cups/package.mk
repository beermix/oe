################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="cups"
PKG_VERSION="2.1.4"
PKG_URL="https://github.com/apple/cups/releases/download/release-2.1.4/cups-2.1.4-source.tar.gz"
PKG_DEPENDS=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="print"
PKG_SHORTDESC="CUPS open source printing system"
PKG_LONGDESC="CUPS is the standards-based, open source printing system developed by Apple Inc. for OS X® and other UNIX®-like operating systems. CUPS uses the Internet Printing Protocol (IPP) to support printing to local and network printers."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  autoconf --include=m4 --force
}

TARGET_CONFIGURE_OPTS="--enable-static \
		       --disable-shared \
		       --disable-webif \
		       --disable-launchd \
		       --disable-dnssd \
		       --disable-avahi \
		       --disable-ssl \
		       --disable-gssapi \
		       --disable-libusb"




