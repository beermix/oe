PKG_NAME="grep"
PKG_VERSION="3.1"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline pcre libcap"
PKG_SECTION="my"


PKG_CONFIGURE_OPTS_TARGET="--disable-perl-regexp"