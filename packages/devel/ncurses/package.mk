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

PKG_CONFIGURE_OPTS_TARGET="--with-shared \
                           --with-normal \
                           --without-debug \
                           --without-ada \
                           --enable-widec \
                           --enable-pc-files \
                           --with-cxx-binding \
                           --with-cxx-shared \
                           --with-pkg-config-libdir=/usr/lib/pkgconfig"

pre_configure_target() {
  # causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
  strip_lto
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fomit-frame-pointer||g"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-fomit-frame-pointer||g"`
  
}

post_makeinstall_target() {
  cp misc/ncurses-config $ROOT/$TOOLCHAIN/bin
  chmod +x $ROOT/$TOOLCHAIN/bin/ncurses-config
  $SED "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" $ROOT/$TOOLCHAIN/bin/ncurses-config
  
  echo "INPUT(-l${lib}w)" > "$pkgdir"/usr/lib/lib${lib}.so
  ln -s ${lib}w.pc "$pkgdir"/usr/lib/pkgconfig/${lib}.pc
  echo "INPUT(-lncursesw)" > "$pkgdir"/usr/lib/libcursesw.so
  ln -s libncurses.so "$pkgdir"/usr/lib/libcurses.so

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
