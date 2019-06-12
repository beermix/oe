PKG_NAME="procps-ng"
PKG_VERSION="3.3.15"
PKG_SHA256="10bd744ffcb3de2d591d2f6acf1a54a7ba070fdcc432a855931a5057149f0465"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/Production/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses systemd"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared \
                           --disable-modern-top \
                           --enable-static"

PKG_MAKE_OPTS_TARGET="free top/top proc/libprocps.la proc/libprocps.pc"

PKG_MAKEINSTALL_OPTS_TARGET="install-libLTLIBRARIES install-pkgconfigDATA"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp -P $PKG_BUILD/.$TARGET_NAME/free $INSTALL/usr/bin
    cp -P $PKG_BUILD/.$TARGET_NAME/top/top $INSTALL/usr/bin

  make DESTDIR=$SYSROOT_PREFIX -j1 $PKG_MAKEINSTALL_OPTS_TARGET
}