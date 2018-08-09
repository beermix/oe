# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libtirpc"
PKG_VERSION="1.0.3"
PKG_SHA256="86c3a78fc1bddefa96111dd233124c703b22a78884203c55c3e06b3be6a0fd5e"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://sourceforge.net/projects/libtirpc/"
PKG_URL="https://downloads.sourceforge.net/project/libtirpc/libtirpc/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="libtirpc: Transport Independent RPC Library"
PKG_LONGDESC="Libtirpc is a port of Suns Transport-Independent RPC library to Linux. It's being developed by the Bull GNU/Linux NFSv4 project."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared \
                           --disable-silent-rules \
                           --with-pic \
                           --disable-ipv6 \
                           --disable-gssapi \
                           --with-gnu-ld"
