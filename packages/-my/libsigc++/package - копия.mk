PKG_NAME="libsigc++"
PKG_VERSION="2.99.7"
PKG_SITE="http://libsigc.sourceforge.net"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.99/libsigc++-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain boost"




pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --disable-documentation \
			   --with-gnu-ld \
			   --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}