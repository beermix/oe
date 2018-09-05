PKG_NAME="grep"
PKG_VERSION="3.1"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline pcre"
PKG_SECTION="sysutils"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-perl-regexp"