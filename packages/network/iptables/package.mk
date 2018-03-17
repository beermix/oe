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
PKG_VERSION="1.6.2"
PKG_SHA256="55d02dfa46263343a401f297d44190f2a3e5113c8933946f094ed40237053733"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.netfilter.org/"
PKG_URL="http://www.netfilter.org/projects/iptables/files/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl libnetfilter_queue libpcap"
#PKG_DEPENDS_TARGET="toolchain linux libmnl libnftnl libpcap libnetfilter_conntrack libnetfilter_queue"
PKG_SECTION="network"
PKG_SHORTDESC="iptables: IP packet filter administration"
PKG_LONGDESC="Iptables is used to set up, maintain, and inspect the tables of IP packet filter rules in the Linux kernel. There are several different tables which may be defined, and each table contains a number of built-in chains, and may contain user-defined chains."
PKG_TOOLCHAIN="autotools"

#post_unpack() {
#  rm $PKG_BUILD/include/linux/types.h
#}

PKG_CONFIGURE_OPTS_TARGET="--enable-bpf-compiler \
			      --enable-devel \
			      --enable-shared \
			      --disable-ipv6 \
			      --with-kernel=$(kernel_path)"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/config/iptables/
    cp -PR $PKG_DIR/config/README $INSTALL/usr/config/iptables/

  mkdir -p $INSTALL/etc/iptables/
    cp -PR $PKG_DIR/config/* $INSTALL/etc/iptables/

  mkdir -p $INSTALL/usr/lib/libreelec
    cp $PKG_DIR/scripts/iptables_helper $INSTALL/usr/lib/libreelec
}

post_install() {
  enable_service iptables.service
}

