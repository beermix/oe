PKG_NAME="db"
PKG_VERSION="4.8.30.NC"
#PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.1.26.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-atomicsupport \
			      --disable-shared \
			      --enable-cxx \
			      --enable-stl \
			      --disable-java \
			      --disable-tcl \
			      --disable-debug"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}