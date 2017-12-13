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

PKG_NAME="rpcbind"
PKG_VERSION="0.2.4"
PKG_SHA256="074a9a530dc7c11e0d905aa59bcb0847c009313f02e98d3d798aa9568f414c66"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://rpcbind.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/rpcbind/rpcbind/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libtirpc systemd"
PKG_SECTION="network"
PKG_SHORTDESC="rpcbind: a server that converts RPC program numbers into universal addresses."
PKG_LONGDESC="The rpcbind utility is a server that converts RPC program numbers into universal addresses."

PKG_CONFIGURE_OPTS_TARGET="--disable-warmstarts \
                           --disable-libwrap \
                           --with-statedir=/tmp \
                           --with-rpcuser=root"

post_install() {
  enable_service rpcbind.service
}
