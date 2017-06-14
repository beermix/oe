PKG_NAME="db"
#PKG_VERSION="4.8.30.NC"
PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.1.26.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#CXXFLAGS="$CXXFLAGS -fno-dwarf2-cfi-asm"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-compat185 \
			      --disable-shared \
			      --enable-static \
			      --enable-cxx \
			      --disable-java \
			      --disable-tcl \
			      --disable-debug \
			      --disable-java \
			      --with-pic \
			      --enable-o_direct \	
			      --enable-mutexsupport"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}