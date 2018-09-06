# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="automake"
PKG_VERSION="1.16.1"
PKG_SHA256="5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://sources.redhat.com/automake/"
PKG_URL="http://ftpmirror.gnu.orgs/automake/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host autoconf:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="automake: A GNU tool for automatically creating Makefiles"
PKG_LONGDESC="This is Automake, a Makefile generator. It was inspired by the 4.4BSD make and include files, but aims to be portable and to conform to the GNU standards for Makefile variables and targets. Automake is a Perl script. The input files are called Makefile.am. The output files are called Makefile.in; they are intended for use with Autoconf. Automake requires certain things to be done in your configure.in."

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --disable-silent-rules"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install

  mkdir -p $TOOLCHAIN/share/aclocal/
  cp -r -i $PKG_DIR/gtk-doc.m4 $TOOLCHAIN/share/aclocal/
}
