# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="autoconf-archive"
PKG_VERSION="2018.03.13"
PKG_SHA256="6175f90d9fa64c4d939bdbb3e8511ae0ee2134863a2c7bf8d9733819efa6e159"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.gnu.org/software/autoconf-archive/"
PKG_URL="http://ftpmirror.gnu.org/autoconf-archive/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="autoconf-archive: macros for autoconf"
PKG_LONGDESC="autoconf-archive is an package of m4 macros"

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --prefix=$TOOLCHAIN"

makeinstall_host() {
# make install
  make prefix=$SYSROOT_PREFIX/usr install

# remove problematic m4 file
  rm -rf $SYSROOT_PREFIX/usr/share/aclocal/ax_prog_cc_for_build.m4
}
