PKG_NAME="dash"
PKG_VERSION="0.5.9.1"
PKG_URL="http://gondor.apana.org.au/~herbert/dash/files/dash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses libedit"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-statcic \
			      --enable-fnmatch \
			      --with-libedit \
			      --enable-glob \
			      --with-sysroot=$SYSROOT_PREFIX"