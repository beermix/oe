PKG_NAME="libtorrent"
PKG_VERSION="0.13.6"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://rtorrent.net/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl curl zlib ncurses libsigc++"


PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr\
			      --enable-static \
			      --enable-aligned \
			      --disable-shared \
			      --disable-debug \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --with-kqueue \
			      --with-posix-fallocate"

