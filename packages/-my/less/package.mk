PKG_NAME="less"
PKG_VERSION="481"
PKG_URL="http://www.greenwoodsoftware.com/less/less-$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="coreutils-1"
PKG_BUILD_DEPENDS_TARGET="toolchain netbsd-curses libedir"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

export LIBS="-ltermcap -lcurses -lterminfo"

export CFLAGS="-Wall -g -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --enable-static --with-gnu-ld"
		
