PKG_NAME="rtorrent"
PKG_VERSION="0.9.6"
PKG_REV="5"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libtorrent.rakshasa.no"
PKG_URL="http://rtorrent.net/downloads/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl curl netbsd-curses libtorrent zlib xmlrpc-c libsigc++"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   export LIBS="-lcurses -lterminfo"
   export LDFLAGS="-Wl,-z,now -Wl,-z,relro -lcurses -lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
			   --disable-ipv6 \
			   --disable-shared \
			   --enable-static \
			   --with-gnu-ld"
			   
# --with-xmlrpc-c=$SYSROOT_PREFIX/usr/bin/xmlrpc-c-config