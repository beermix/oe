PKG_NAME="automake-1.11"
PKG_VERSION="1.11"
PKG_URL="http://ftp.gnu.org/gnu/automake/automake-1.11.6.tar.xz"
PKG_SOURCE_DIR="automake-1.11.6"
PKG_DEPENDS_HOST="ccache:host autoconf:host"

PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --disable-silent-rules --program-suffix=-1.11"

post_makeinstall_host() {
  make prefix=$SYSROOT_PREFIX/usr install
}
