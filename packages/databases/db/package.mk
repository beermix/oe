PKG_NAME="db"
PKG_VERSION="4.7.25.NC"
#PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.1.26.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#CXXFLAGS="$CXXFLAGS -fno-dwarf2-cfi-asm"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-java \
			      --disable-tcl \
			      --disable-rpc \
			      --enable-compat185 \
			      --disable-debug \
			      --enable-cxx"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}