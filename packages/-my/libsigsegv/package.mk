PKG_NAME="libsigsegv"
PKG_VERSION="2.10"
PKG_URL="https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET=""

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   strip_lto
   cd $PKG_BUILD
}

PKG_CONFIGURE_OPTS_HOST="--enable-static \
			 --disable-shared"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"