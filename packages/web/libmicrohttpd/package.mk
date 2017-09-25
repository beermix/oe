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

PKG_NAME="libmicrohttpd"
PKG_VERSION="0.9.51"
PKG_ARCH="any"
PKG_LICENSE="LGPLv2.1"
PKG_SITE="https://ftp.gnu.org/gnu/libmicrohttpd/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/libmicrohttpd/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgcrypt"
PKG_SECTION="web"
PKG_SHORTDESC="libmicrohttpd: a small webserver C library"
PKG_LONGDESC="GNU libmicrohttpd is a small C library that is supposed to make it easy to run an HTTP server as part of another application."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --disable-doc \
			      --disable-examples \
			      --disable-curl \
			      --disable-spdy \
			      --with-pic \
			      --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

