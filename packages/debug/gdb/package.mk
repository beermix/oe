# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gdb"
PKG_VERSION="8.2"
PKG_SHA256="c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/gdb/"
PKG_URL="http://ftpmirror.gnu.org/gdb/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib ncurses expat"
PKG_LONGDESC="GNU Project debugger, allows you to see what is going on inside another program while it executes."
# gdb could fail on runtime if build with LTO support

CC_FOR_BUILD="$HOST_CC"
CFLAGS_FOR_BUILD="$HOST_CFLAGS"

PKG_CONFIGURE_OPTS_TARGET="bash_cv_have_mbstate_t=set \
                           --disable-shared \
                           --enable-static \
                           --with-auto-load-safe-path=/ \
                           --disable-nls \
                           --disable-sim \
                           --without-x \
                           --disable-tui \
                           --disable-libada \
                           --without-lzma \
                           --disable-libquadmath \
                           --disable-libquadmath-support \
                           --enable-libada \
                           --enable-libssp \
                           --disable-werror"

makeinstall_target() {
  make DESTDIR=$INSTALL install
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/gdb/python
}
