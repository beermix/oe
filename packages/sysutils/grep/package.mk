PKG_NAME="grep"
PKG_VERSION="3.3"
PKG_SHA256="b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline pcre"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--without-included-regex"