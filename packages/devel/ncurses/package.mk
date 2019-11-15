# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ncurses"
PKG_VERSION="6.0"
PKG_SHA256="f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260"
PKG_SITE="http://invisible-mirror.net/archives/ncurses/current/?C=M;O=D"
PKG_URL="http://invisible-mirror.net/archives/ncurses/ncurses-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="A library is a free software emulation of curses in System V Release 4.0, and more."
# causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.

PKG_CONFIGURE_OPTS_TARGET="--enable-overwrite \
			      --disable-termcap \
			      --disable-warnings \
			      --with-termlib=tinfo \
			      --with-ticlib \
			      --with-ncursesw \
			      --disable-rpath \
			      --without-ada \
			      --without-tests \
			      --without-debug \
			      --without-manpages \
			      --with-shared \
			      --enable-static \
			      --with-progs \
			      --enable-pc-files \
			      --enable-widec \
			      --with-pkg-config-libdir=/usr/lib/pkgconfig \
			      --with-build-cppflags=-D_GNU_SOURCE"
			      
PKG_CONFIGURE_OPTS_HOST="--enable-overwrite \
			    --disable-termcap \
			    --disable-warnings \
			    --without-ncursesw \
			    --disable-rpath \
			    --without-ada \
			    --without-tests \
			    --without-debug \
			    --without-manpages \
			    --without-shared \
			    --enable-static \
			    --without-progs \
			    --enable-pc-files \
			    --enable-widec \
			    --with-pkg-config-libdir=$TOOLCHAIN/lib/pkgconfig \
			    --with-build-cppflags=-D_GNU_SOURCE"

post_makeinstall_target() {
  cp misc/ncurses-config $TOOLCHAIN/bin
  chmod +x $TOOLCHAIN/bin/ncurses-config
  sed -e "s:\(['=\" ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $TOOLCHAIN/bin/ncurses-config

  ln -sf ncursesw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/ncurses.pc
  ln -sf formw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/form.pc
  ln -sf menuw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/menu.pc
  ln -sf panelw.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/panel.pc
  ln -sf tinfow.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/tinfo.pc
  
  echo "INPUT(-lncursesw -ltinfo)" > $INSTALL/usr/lib/libncurses.so
  echo "INPUT(-lncursesw -ltinfo)" > $SYSROOT_PREFIX/usr/lib/libncurses.so

  echo "INPUT(-lncursesw -ltinfo)" > $INSTALL/usr/lib/libcursesw.so
  echo "INPUT(-lncursesw -ltinfo)" > $SYSROOT_PREFIX/usr/lib/libcursesw.so
  
  ln -s libncurses.so $INSTALL/usr/lib/libcurses.so
  ln -sf libncurses.so $SYSROOT_PREFIX/usr/lib/libcurses.so

  ln -sf libformw.so $SYSROOT_PREFIX/usr/lib/libform.so
  ln -sf libmenuw.so $SYSROOT_PREFIX/usr/lib/libmenu.so
  ln -sf libpanelw.so $SYSROOT_PREFIX/usr/lib/libpanel.so
  ln -sf ticw.so $SYSROOT_PREFIX/usr/lib/tic.so

  ln -s libformw.so $INSTALL/usr/lib/libform.so
  ln -s libmenuw.so $INSTALL/usr/lib/libmenu.so
  ln -s libpanelw.so $INSTALL/usr/lib/libpanel.so
  ln -s ticw.so $INSTALL/usr/lib/tic.so

  rm -rf $INSTALL/usr/bin/ncurses*-config
}
