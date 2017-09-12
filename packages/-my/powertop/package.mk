PKG_NAME="powertop"
PKG_VERSION="f3f350f"
PKG_GIT_URL="https://github.com/fenrus75/powertop"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  #cd $ROOT/$PKG_BUILD
  NOCONFIGURE=1 ./autogen.sh
  
  LDFLAGS="$LDFLAGS -lpci -ludev"
  
# LDFLAGS="$LDFLAGS -lpthread -lm"
# CFLAGS="$CFLAGS -D_GNU_SOURCE -DCONFIG_LIBNL20 -I$SYSROOT_PREFIX/usr/include"
# CPPFLAGS="-D_GNU_SOURCE -Dresetterm=reset_shell_mode"
# LDFLAGS="$LDFLAGS -Wl,-rpath-link=$SYSROOT_PREFIX/lib -lz"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --disable-rpath \
			      --disable-silent-rules \
			      --with-gnu-ld \
			      --disable-shared \
			      --enable-static"