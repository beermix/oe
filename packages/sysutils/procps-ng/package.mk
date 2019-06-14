PKG_NAME="procps-ng"
PKG_VERSION="3.3.15"
PKG_SHA256="10bd744ffcb3de2d591d2f6acf1a54a7ba070fdcc432a855931a5057149f0465"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/Production/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses systemd"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  sed -i 's:<ncursesw/:<:g' -i $PKG_BUILD/watch.c
  cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared --enable-static \
                           --disable-modern-top \
                           --enable-watch8bit \
                           --with-systemd \
                           --disable-kill"

#PKG_MAKE_OPTS_TARGET="free top/top proc/libprocps.la proc/readproc.h proc/libprocps.pc"

#PKG_MAKEINSTALL_OPTS_TARGET="install-libLTLIBRARIES install-pkgconfigDATA"

#makeinstall_target() {
#  mkdir -p $INSTALL/usr/bin
#    cp -P $PKG_BUILD/free $INSTALL/usr/bin
#    cp -P $PKG_BUILD/top/top $INSTALL/usr/bin
#
#  make DESTDIR=$SYSROOT_PREFIX -j1 $PKG_MAKEINSTALL_OPTS_TARGET
#}

post_makeinstall_target() {
  rm $INSTALL/usr/bin/pmap
  rm $INSTALL/usr/bin/pwdx
  rm $INSTALL/usr/bin/slabtop
  rm $INSTALL/usr/bin/uptime
  rm $INSTALL/usr/bin/vmstat
  rm $INSTALL/usr/bin/w
  rm $INSTALL/usr/bin/pgrep
  rm $INSTALL/usr/bin/pidof
  rm $INSTALL/usr/bin/pkill
  rm $INSTALL/usr/bin/ps
  rm $INSTALL/usr/bin/tload
  #rm $INSTALL/usr/bin/watch

  rm -rf $INSTALL/usr/sbin
}
