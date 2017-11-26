PKG_NAME="findutils"
PKG_VERSION="4.6.0"
PKG_URL="http://ftpmirror.gnu.org/findutils/findutils-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"


PKG_CONFIGURE_OPTS_TARGET="--without-selinux --disable-debug --enable-threads=posix"