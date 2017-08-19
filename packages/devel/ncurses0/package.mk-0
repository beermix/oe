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
PKG_SITE="http://invisible-mirror.net/archives/ncurses/current/?C=M;O=D"
PKG_URL="http://invisible-mirror.net/archives/ncurses/current/ncurses-$PKG_VERSION.tgz"
#PKG_VERSION="52681a6"
#PKG_GIT_URL="git://anonscm.debian.org/collab-maint/ncurses.git"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_DEPENDS_HOST="zlib:host"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--without-ada \
                           --without-cxx \
                           --without-cxx-binding \
                           --with-progs \
                           --with-shared \
                           --without-debug \
                           --without-manpages \
                           --without-hashed-db \
                           --with-cxx-shared \
                           --disable-termcap \
                           --enable-symlinks \
                           --with-rcs-ids \
                           --enable-const \
                           --enable-colorfgbg \
                           --enable-hard-tabs \
                           --enable-echo \
                           --enable-pc-files \
                           --with-pkg-config-libdir=/usr/lib/pkgconfig \
                           --enable-widec \
                           --disable-warnings"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
  chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config

  ln -sfv ncursesw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/ncurses.pc
  
  echo "INPUT(-lncursesw)" > $INSTALL/usr/lib/libncurses.so
  echo "INPUT(-lncursesw)" > $SYSROOT_PREFIX/usr/lib/libncurses.so

  echo "INPUT(-lncursesw)" > $INSTALL/usr/lib/libcursesw.so
  echo "INPUT(-lncursesw)" > $SYSROOT_PREFIX/usr/lib/libcursesw.so

  ln -sfv libncurses.so $INSTALL/usr/lib/libcurses.so
  ln -sfv libncurses.so $SYSROOT_PREFIX/usr/lib/libcurses.so
  
  ln -sfv libformw.so $INSTALL/usr/lib/libform.so
  ln -sfv libmenuw.so $INSTALL/usr/lib/libmenu.so
  ln -sfv libpanelw.so $INSTALL/usr/lib/libpanel.so
  #ln -sfv ticw.so $INSTALL/usr/lib/tic.so
  #ln -sfv libtinfow.so $INSTALL/usr/lib/libtinfo.so
  
  ln -sfv libformw.so $SYSROOT_PREFIX/usr/lib/libform.so
  ln -sfv libmenuw.so $SYSROOT_PREFIX/usr/lib/libmenu.so
  ln -sfv libpanelw.so $SYSROOT_PREFIX/usr/lib/libpanel.so
  #ln -sfv ticw.so $SYSROOT_PREFIX/usr/lib/tic.so
  #ln -sfv libtinfow.so $SYSROOT_PREFIX/usr/lib/libtinfo.so
  
  rm -rf $INSTALL/usr/bin/ncurses*-config
}
