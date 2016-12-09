PKG_NAME="jpeg"
PKG_VERSION="9b"
PKG_URL="http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
#PKG_SOURCE_DIR="aufs2-util"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-sysroot=$SYSROOT_PREFIX \
			   --with-gnu-ld"
	

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}