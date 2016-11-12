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

PKG_NAME="ncurses"
PKG_VERSION="6.0-20161105"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://www.gnu.org/software/ncurses/"
PKG_URL="https://dl.dropboxusercontent.com/s/8tbfc1h0dmxum31/ncurses-6.0-20160625.tar.xz"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--without-ada \
                           --with-cxx \
                           --without-cxx-binding \
                           --disable-db-install \
                           --without-manpages \
                           --without-profile \
                           --enable-echo \
                           --enable-const \
                           --with-versioned-syms \
                           --with-xterm-kbs=del \
                           --with-ncursesw \
                           --without-progs \
                           --without-tests \
                           --with-curses-h \
                           --without-shared \
                           --with-normal \
                           --without-debug \
                           --disable-rpath \
                           --with-fallbacks=linux,screen,xterm,xterm-256color \
                           --with-ticlib \
                           --enable-getcap \
                           --enable-getcap-cache \
                           --enable-symlinks \
                           --enable-ext-funcs \
                           --enable-pc-files \
                           --enable-widec"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
  CFLAGS="$CFLAGS -D_GNU_SOURCE -fPIC"
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
    chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
    $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
  ln -sf ncurses-config $ROOT/$TOOLCHAIN/bin/ncurses5-config
  ln -sf ncurses5-config $ROOT/$TOOLCHAIN/bin/ncurses6-config

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
