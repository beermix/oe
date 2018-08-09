PKG_NAME="db"
#PKG_VERSION="4.7.25.NC"
PKG_VERSION="4.8.30.NC"
#PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.2.32.NC" --disable-atomicsupport
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-compat185 \
			      --disable-shared \
			      --enable-static \
			      --enable-cxx \
			      --enable-dbm \
			      --enable-stl"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}

