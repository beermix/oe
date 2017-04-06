PKG_NAME="db"
#PKG_VERSION="4.8.30.NC"
PKG_VERSION="5.3.28.NC"
#PKG_VERSION="6.1.26.NC"
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -fPIC"
#  export CXXFLAGS="$CXXFLAGS -fPIC"
#  export LDFLAGS="$LDFLAGS -fPIC"
#}

PKG_CONFIGURE_SCRIPT="dist/configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-smallbuild \
			      --disable-debug_rop \
			      --disable-debug_wop \
			      --disable-diagnostic \
			      --disable-java \
			      --enable-cxx \
			      --enable-posixmutexes \
			      --disable-uimutexes \
			      --disable-tcl \
			      --enable-compat185 \
			      --disable-statistics \
			      --disable-replication \
			      --disable-cryptography \
			      --disable-queue \
			      --disable-debug"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}