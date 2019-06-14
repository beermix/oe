PKG_NAME="help2man"
PKG_VERSION="1.47.5"
PKG_URL="https://ftp.gnu.org/gnu/help2man/help2man-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"