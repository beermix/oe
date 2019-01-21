PKG_NAME="db"
#PKG_VERSION="4.7.25.NC"
PKG_VERSION="4.8.30.NC"
#PKG_VERSION="5.3.21.NC"
#PKG_VERSION="6.2.32.NC" 			      --with-mutex=POSIX/pthreads/library \
PKG_URL="http://download.oracle.com/berkeley-db/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"

configure_package() {
  PKG_CONFIGURE_SCRIPT="$PKG_BUILD/dist/configure"
  PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
  				 --enable-static \
  				 --disable-java \
  				 --disable-tcl \
  				 --enable-compat185 \
  				 --disable-debug \
  				 --enable-cxx \
  				 --with-pic \
  				 --disable-atomicsupport"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}

