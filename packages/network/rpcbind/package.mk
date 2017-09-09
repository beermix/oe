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
PKG_SITE="http://rpcbind.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/rpcbind/rpcbind/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libtirpc"
PKG_SECTION="network"
PKG_SHORTDESC="rpcbind: a server that converts RPC program numbers into universal addresses."
PKG_LONGDESC="The rpcbind utility is a server that converts RPC program numbers into universal addresses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-warmstarts \
                           --disable-libwrap \
                           --with-statedir=/run \
                           --with-rpcuser=root"

post_install() {
  enable_service rpcbind.service
}
