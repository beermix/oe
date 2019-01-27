# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="automake"
PKG_VERSION="1.16.1"
PKG_SHA256="5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921"
PKG_LICENSE="GPL"
PKG_SITE="http://sources.redhat.com/automake/"
PKG_URL="http://ftpmirror.gnu.org/automake/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host autoconf:host"
PKG_LONGDESC="A GNU tool for automatically creating Makefiles."

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --disable-silent-rules"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install
  
#  ln -sf automake-1.16 $TOOLCHAIN/bin/automake-1.15
#  ln -sf aclocal-1.16 $TOOLCHAIN/bin/aclocal-1.15
}
