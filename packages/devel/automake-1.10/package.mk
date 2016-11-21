PKG_NAME="automake-1.10"
PKG_VERSION="1.10"
PKG_URL="http://ftp.gnu.org/gnu/automake/automake-1.10.2.tar.bz2"
PKG_SOURCE_DIR="automake-1.10.2"
PKG_DEPENDS_HOST="ccache:host autoconf:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --disable-silent-rules"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install
}
