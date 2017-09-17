PKG_NAME="findutils"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin --without-selinux --disable-debug --enable-leaf-optimisation --disable-nls"