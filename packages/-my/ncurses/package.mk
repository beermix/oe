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
PKG_VERSION="6.0-20170114"
PKG_SITE="http://www.gnu.org/software/ncurses/"
PKG_URL="ftp://invisible-island.net/ncurses/current/ncurses-6.0-20170114.tgz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_SHORTDESC="ncurses: The ncurses (new curses) library"
PKG_LONGDESC="The ncurses (new curses) library is a free software emulation of curses in System V Release 4.0, and more. It uses terminfo format, supports pads and color and multiple highlights and forms characters and function-key mapping, and has all the other SYSV-curses enhancements over BSD curses."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
                        
PKG_CONFIGURE_OPTS_TARGET="--with-pkg-config-libdir=/usr/lib/pkgconfig \
			      --enable-pc-files \
			      --enable-echo \
			      --enable-const \
			      --enable-overwrite \
			      --disable-rpath \
			      --without-ada \
			      --without-debug \
			      --without-manpages \
			      --without-profile \
			      --without-progs \
			      --without-tests \
			      --disable-big-core \
			      --disable-home-terminfo \
			      --with-normal \
			      --with-shared \
			      --with-terminfo-dirs=/usr/share/terminfo \
			      --with-default-terminfo-dir=/usr/share/terminfo \
			      --with-pkg-config-libdir=/usr/lib/pkgconfig \
			      --enable-widec \
			      --with-build-cppflags=-D_GNU_SOURCE"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
  #export CFLAGS="$CFLAGS -D_DEFAULT_SOURCE -D_POSIX_C_SOURCE=200809C -fPIC" --without-curses-h
  #export CFLAGS="$CFLAGS -fPIC"
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
  chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
  ln -sf ncurses-config $ROOT/$TOOLCHAIN/bin/ncurses5-config
  ln -sf ncurses5-config $ROOT/$TOOLCHAIN/bin/ncurses6-config

  rm -rf $INSTALL/usr/bin/ncurses*-config
  #rm -rf $INSTALL/root
  #cp misc/formw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  #cp misc/menuw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  #cp misc/ncursesw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  #cp misc/ticw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  #cp misc/tinfow.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
  #rm -rf $SYSROOT_PREFIX/root/-f2fs
}
