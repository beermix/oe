PKG_NAME="powertop"
PKG_VERSION="16b788f"
PKG_URL="https://github.com/fenrus75/powertop/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_TOOLCHAIN="manual"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  #cd $PKG_BUILD
  NOCONFIGURE=1 ./autogen.sh
  
  export LIBS="$LIBS -lpci -lz -ludev"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --disable-rpath \
			      --enable-silent-rules \
			      --disable-shared \
			      --enable-static"
