################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="ncurses"
PKG_VERSION="6.0-20170812"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="http://invisible-mirror.net/archives/ncurses/current/?C=M;O=D"
PKG_URL="http://invisible-mirror.net/archives/ncurses/current/ncurses-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--without-ada \
                           --with-cxx \
                           --without-cxx-binding \
                           --without-manpages \
                           --without-profile \
                           --enable-echo \
                           --enable-const \
                           --with-versioned-syms \
                           --with-xterm-kbs=del \
                           --with-ncursesw \
                           --with-progs \
                           --without-tests \
                           --with-curses-h \
                           --with-shared \
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
                           --with-pkg-config-libdir=/usr/lib/pkgconfig \
                           --enable-widec \
                           --enable-sigwinch \
                           --disable-nls \
                           --without-dlsym \
                           --with-x"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
  chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
  ln -sf ncurses-config $ROOT/$TOOLCHAIN/bin/ncurses5-config
  #ln -sf ncurses5-config $ROOT/$TOOLCHAIN/bin/ncurses6-config

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
