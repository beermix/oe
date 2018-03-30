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

PKG_NAME="libxslt"
PKG_VERSION="1.1.33-rc1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="https://git.gnome.org//browse/libxslt/"
PKG_URL="https://git.gnome.org/browse/libxslt/snapshot/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libxml2:host"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_SECTION="textproc"
PKG_SHORTDESC="libxslt"
PKG_LONGDESC="libxslt"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="  ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --without-python \
                           --enable-static \
                           --enable-shared \
                           --with-libxml-prefix=$TOOLCHAIN \
                           --without-crypto"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_ansidecl_h=no \
                           ac_cv_header_xlocale_h=no \
                           --without-python \
                           --enable-static \
                           --enable-shared \
                           --with-libxml-prefix=$SYSROOT_PREFIX/usr \
                           --with-crypto=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  $SED "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $SYSROOT_PREFIX/usr/bin/xslt-config

  rm -rf $INSTALL/usr/bin/xsltproc
  rm -rf $INSTALL/usr/lib/xsltConf.sh
}
