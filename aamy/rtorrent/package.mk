PKG_NAME="rtorrent"
PKG_VERSION="0.9.6"
PKG_SITE="https://github.com/rakshasa/rtorrent"
PKG_GIT_URL="https://github.com/rakshasa/rtorrent"
PKG_DEPENDS_TARGET="toolchain openssl curl ncurses libtorrent zlib xmlrpc-c libsigc++"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug --disable-ipv6 --disable-shared --with-gnu-ld"