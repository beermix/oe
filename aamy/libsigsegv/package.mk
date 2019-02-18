PKG_NAME="libsigsegv"
PKG_VERSION="2.12"
PKG_URL="https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET=""
PKG_SECTION="devel"
#PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic:host +pic"

#pre_configure_target() {
#   cd $PKG_BUILD
#}

PKG_CONFIGURE_OPTS_HOST="sv_cv_fault_posix=yes --enable-static --disable-shared"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"