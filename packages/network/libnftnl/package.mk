# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libnftnl"
PKG_VERSION="1.0.9"
PKG_SHA256="fec1d824aee301e59a11aeaae2a2d429cb99ead81e6bafab791a4dd6569b3635"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://netfilter.org/projects/libnftnl"
PKG_URL="http://netfilter.org/projects/libnftnl/files/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libmnl"
PKG_SECTION="network"
PKG_SHORTDESC="libnftnl: a userspace library providing a low-level netlink programming interface (API) to the in-kernel nf_tables subsystem."
PKG_LONGDESC="libnftnl is a userspace library providing a low-level netlink programming interface (API) to the in-kernel nf_tables subsystem. The library libnftnl has been previously known as libnftables. This library is currently used by nftables."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
