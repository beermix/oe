PKG_NAME="grep"
PKG_VERSION="2.27"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain readline gettext pcre libcap libxml2"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
		
