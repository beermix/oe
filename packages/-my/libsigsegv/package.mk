PKG_NAME="libsigsegv"
PKG_VERSION="2.10"
PKG_URL="https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET=""
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--enable-static \
			 --disable-shared \
			 --disable-silent-rules"