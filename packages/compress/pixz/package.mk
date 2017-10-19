PKG_NAME="pixz"
PKG_VERSION="4f079c3"
PKG_GIT_URL="https://github.com/vasi/pixz"
PKG_DEPENDS_TARGET="toolchain xz libarchive"
PKG_DEPENDS_HOST="zlib:host lzo:host xz:host bzip2:host"
PKG_SECTION="compress"

PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_file_src_pixz_1=yes \
			      ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --disable-shared \
			      --enable-largefile \
			      --without-manpage"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

