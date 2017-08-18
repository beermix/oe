PKG_NAME="db"
#PKG_VERSION="4.7.25.NC"
PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.1.26.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-compat185 \
			      --enable-shared \
			      --enable-static \
			      --enable-cxx \
			      --enable-dbm \
			      --disable-stl \
			      --disable-java \
			      --disable-tcl \
			      --disable-rpc \
			      --disable-debug"
			      
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
			   
#post_makeinstall_target() {
#  rm -rf $INSTALL
#}

#make_target() {
#  make LIBSO_LIBS=-lpthread
#}

#make_host() {
#  make LIBSO_LIBS=-lpthread
#}
