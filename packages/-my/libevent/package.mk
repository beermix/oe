PKG_NAME="libevent"
PKG_VERSION="2.0.22-stable"
#PKG_VERSION="release-2.1.7-rc"
PKG_URL="http://switch.dl.sourceforge.net/project/levent/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   export LIBS="$LIBS -lz"
   export CFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-samples \
			      --enable-openssl"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
