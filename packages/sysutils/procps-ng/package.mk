PKG_NAME="procps-ng"
PKG_VERSION="3.3.15"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/Production/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"
#PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
 sed 's:<ncursesw/:<:g' -i $PKG_BUILD/watch.c
 cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-modern-top \
                           --enable-watch8bit \
                           --with-systemd \
                           --disable-shared \
                           --disable-kill"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/sbin
}
