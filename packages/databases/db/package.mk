PKG_NAME="db"
#PKG_VERSION="4.7.25.NC"
PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.2.32.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain db:host"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-compat185 \
			      --enable-shared \
			      --enable-dbm \
			      --enable-cxx \
			      --enable-stl \
			      --disable-java \
			      --disable-debug"
			      
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
			   
post_makeinstall_target() {
  rm -rf $INSTALL/usr/docs
}
