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
PKG_VERSION="6.0-20170729"
PKG_SITE="ftp://invisible-island.net/ncurses/current/"
PKG_URL="ftp://invisible-island.net/ncurses/current/ncurses-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."




PKG_CONFIGURE_OPTS_HOST="--with-shared \
			    --without-gpm \
			    --without-manpages \
			    --without-cxx \
			    --without-cxx-binding \
			    --without-ada \
			    --without-normal"

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
                           --with-progs \
                           --without-tests \
                           --with-curses-h \
                           --without-shared \
                           --with-normal \
                           --without-debug \
                           --with-fallbacks=linux,screen,xterm,xterm-256color \
                           --with-ticlib \
                           --enable-getcap \
                           --disable-rpath-hack \
                           --enable-getcap-cache \
                           --disable-symlinks \
                           --enable-ext-funcs \
                           --disable-pc-files \
                           --enable-widec \
                           --enable-sigwinch \
                           --disable-nls \
                           --without-dlsym \
                           --with-x"
                           
makeinstall_host() {
  : # nop
}


pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
  export CFLAGS="$CFLAGS -fPIC"
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
}

post_makeinstall_target() {
  cp misc/ncurses-config $TOOLCHAIN/bin
  chmod +x $TOOLCHAIN/bin/ncurses-config
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $TOOLCHAIN/bin/ncurses-config
  ln -sf ncurses-config $TOOLCHAIN/bin/ncurses5-config
  ln -sf ncurses5-config $TOOLCHAIN/bin/ncurses6-config

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
