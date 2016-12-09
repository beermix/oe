PKG_NAME="grep"
PKG_VERSION="2.26"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
#PKG_SOURCE_DIR="coreutils-1"
PKG_BUILD_DEPENDS_TARGET="toolchain readline gettext pcre libcap texinfo libxml2"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -Ofast"
}

PKG_CONFIGURE_OPTS_TARGET="\
		--prefix=/usr \
		--with-gnu-ld \
		--enable-pcre \
		--disable-shared \
		--enable-static"
		
