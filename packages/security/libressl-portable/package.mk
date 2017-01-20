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

PKG_NAME="openssl-portable"
PKG_VERSION="2.5.0"
PKG_SITE="http://www.openssl.org/"
PKG_URL="http://ftp.openbsd.org/pub/OpenBSD/openssl/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="security"
PKG_SHORTDESC="openssl: a FREE version of the SSL/TLS protocol forked from openssl"
PKG_LONGDESC="openssl is a FREE version of the SSL/TLS protocol forked from openssl"

PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

post_makeinstall_target() {
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp $PKG_DIR/config/*.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
}
