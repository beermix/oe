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

PKG_NAME="iptables"
PKG_VERSION="20170818"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.netfilter.org/"
PKG_URL="ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-20170818.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl libnetfilter_acct libnetfilter_conntrack libnetfilter_queue"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="iptables: IP packet filter administration"
PKG_LONGDESC="Iptables is used to set up, maintain, and inspect the tables of IP packet filter rules in the Linux kernel. There are several different tables which may be defined, and each table contains a number of built-in chains, and may contain user-defined chains."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="$CFLAGS -ffunction-sections -fdata-sections -DNO_LEGACY"
LDFLAGS="$LDFLAGS -Wl,--gc-sections"
CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"

PKG_CONFIGURE_OPTS_TARGET="--disable-ipv6 --with-kernel=$(get_pkg_build linux)"
