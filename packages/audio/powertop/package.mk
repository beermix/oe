PKG_NAME="powertop"
PKG_VERSION="746abef"
PKG_GIT_URL="https://github.com/fenrus75/powertop"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  # unset LIBTOOL because freetype uses its own
    ( unset LIBTOOL
      sh autogen.sh
    )
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"