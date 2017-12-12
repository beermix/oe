PKG_NAME="guile"
PKG_VERSION="2.0.12"
PKG_SITE="http://sources.redhat.com/autogen/"
PKG_URL="ftp://ftp.gnu.org/gnu/guile/guile-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="toolchain libffi libunistring readline"
PKG_DEPENDS_TARGET="toolchain zlib readline libtool gmp libunistring libffi"

PKG_SECTION="toolchain/devel"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
   strip_lto
}
PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --with-threads"
	

PKG_CONFIGURE_OPTS_HOST="--prefix=/usr \
			 --disable-shared \
			 --enable-static \
			 --with-gnu-ld \
			 --with-threads"