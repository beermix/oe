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

PKG_NAME="pcre"
PKG_VERSION="8.41"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.pcre.org/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-unicode-properties \
			      --enable-pcre16 \
			      --enable-pcre32 \
			      --enable-jit \
			      --enable-utf8"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET --disable-shared --with-pic"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}

post_makeinstall_host() {
  rm $TOOLCHAIN/bin/$PKG_NAME-config
}