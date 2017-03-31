PKG_NAME="lrzip"
PKG_VERSION="ac393ef"
PKG_GIT_URL="https://github.com/ckolivas/lrzip"
PKG_DEPENDS_TARGET="toolchain xz lzo zlib bzip2"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static 
			      --disable-silent-rules \
			      --enable-largefile \
			      --disable-doc \
			      --with-pic"

