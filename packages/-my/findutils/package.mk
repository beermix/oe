PKG_NAME="findutils"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --without-selinux \
			   --disable-debug \
			   --disable-nls \
			   --enable-threads=posix \
			   --enable-static"