PKG_NAME="procps-ng"
PKG_VERSION="3.3.15"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/Production/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  sed 's:<ncursesw/:<:g' -i $PKG_BUILD/watch.c
  cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-modern-top \
                           --enable-watch8bit \
                           --disable-shared \
                           --disable-kill"

PKG_MAKE_OPTS_TARGET="top/top proc/libprocps.la proc/libprocps.pc"

PKG_MAKEINSTALL_OPTS_TARGET="install-libLTLIBRARIES install-pkgconfigDATA"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin

  make DESTDIR=$SYSROOT_PREFIX -j1 $PKG_MAKEINSTALL_OPTS_TARGET
}