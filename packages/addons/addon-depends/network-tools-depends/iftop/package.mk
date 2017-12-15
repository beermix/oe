################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="iftop"
PKG_VERSION="1.0pre4"
PKG_SHA256="f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://htop.sourceforge.net/"
PKG_URL="http://www.ex-parrot.com/pdw/iftop/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libpcap libnl"
PKG_SECTION="network/analyzer"
PKG_SHORTDESC="iftop: display bandwidth usage on an interface"
PKG_LONGDESC="iftop does for network usage what top(1) does for CPU usage. It listens to network traffic on a named interface and displays a table of current bandwidth usage by pairs of hosts. Handy for answering the question 'why is our ADSL link so slow?'."
PKG_TOOLCHAIN="autotools"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_configure_target() {
  export LIBS="-lpcap -lnl-3 -lnl-genl-3 -lncurses"
}

makeinstall_target() {
  : # nop
}
