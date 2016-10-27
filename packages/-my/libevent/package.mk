PKG_NAME="libevent"
PKG_VERSION="release-2.0.22-stable"
PKG_GIT_URL="https://github.com/libevent/libevent"
PKG_DEPENDS_TARGET="toolchain openssl openssl"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --disable-samples \
			   --disable-debug-mode"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
