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

PKG_NAME="cups"
PKG_VERSION="1.7.1"
PKG_SITE="http://www.cups.org"
PKG_URL="https://www.cups.org/software/$PKG_VERSION/$PKG_NAME-$PKG_VERSION-source.tar.bz2"
#PKG_URL="https://github.com/apple/cups/releases/download/v$PKG_VERSION/cups-$PKG_VERSION-source.tar.gz"
PKG_DEPENDS_TARGET="toolchain avahi zlib openssl"
PKG_SECTION="depends"
PKG_SHORTDESC="CUPS printing system"
PKG_LONGDESC="CUPS is the standards-based, open source printing system developed by Apple Inc. for macOS® and other UNIX®-like operating sysms"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="--disable-webif \
			      --disable-launchd \
			      --disable-dnssd \
			      --disable-avahi \
			      --disable-ssl \
			      --disable-gssapi \
			      --disable-libusb"


makeinstall_target() {
  $ROOT/$TOOLCHAIN/bin/make -j1 DESTDIR=$SYSROOT_PREFIX install-libs install-headers
  make DESTDIR=$INSTALL install-libs
  if test -d $INSTALL/usr/lib64; then
    mv $INSTALL/usr/lib64 $INSTALL/usr/lib
  fi
}