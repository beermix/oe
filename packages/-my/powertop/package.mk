PKG_NAME="powertop"
PKG_VERSION="f3f350f"
PKG_URL="https://github.com/fenrus75/powertop/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  #cd $PKG_BUILD
  NOCONFIGURE=1 ./autogen.sh
  
  LDFLAGS="$LDFLAGS -lpci -ludev"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --disable-rpath \
			      --disable-silent-rules \
			      --disable-shared \
			      --enable-static"