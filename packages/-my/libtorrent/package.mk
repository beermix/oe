PKG_NAME="libtorrent"
PKG_VERSION="0.13.6"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://rtorrent.net/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl curl zlib netbsd-curses libsigc++"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr\
			   --enable-static \
			   --enable-aligned \
			   --disable-shared \
			   --disable-debug \
			   --with-zlib=$ROOT/$TOOLCHAIN \
			   --with-kqueue \
			   --with-posix-fallocate"

