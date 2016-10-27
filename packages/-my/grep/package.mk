PKG_NAME="grep"
PKG_VERSION="2.26"
PKG_URL="http://ftp.gnu.org/gnu/grep/grep-$PKG_VERSION.tar.xz"
#PKG_SOURCE_DIR="coreutils-1"
PKG_BUILD_DEPENDS_TARGET="toolchain readline gettext pcre libcap texinfo libxml2"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#CFLAGS="-Ofast -O3 -fPIC"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"


PKG_CONFIGURE_OPTS_TARGET="\
		--prefix=/usr \
		--with-gnu-ld \
		--enable-pcre \
		--disable-shared \
		--enable-static"
		
