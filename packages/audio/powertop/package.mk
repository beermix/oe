PKG_NAME="powertop"
PKG_VERSION="v2.9"
PKG_GIT_URL="https://github.com/fenrus75/powertop"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  sh autogen.sh
}

configure_target() {  
  LDFLAGS="$LDFLAGS -lpthread -lm"
  CFLAGS="$CFLAGS -D_GNU_SOURCE -DCONFIG_LIBNL20 -I$SYSROOT_PREFIX/usr/include"
  CPPFLAGS="-D_GNU_SOURCE -Dresetterm=reset_shell_mode" \
  LDFLAGS="$optldflags -Wl,-rpath-link=$SYSROOT_PREFIX/lib -lz"
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_search_delwin=-lncurses --disable-nls"