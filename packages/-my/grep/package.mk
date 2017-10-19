PKG_NAME="grep"
PKG_VERSION="3.1"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain readline pcre libcap libxml2"
PKG_SECTION="my"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin --enable-threads=posix"