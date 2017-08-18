PKG_NAME="libevent"
PKG_VERSION="release-2.1.8-stable"
PKG_GIT_URL="https://github.com/libevent/libevent"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-samples \
			      --enable-openssl \
			      --disable-debug-mode \
			      --with-gnu-ld"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
