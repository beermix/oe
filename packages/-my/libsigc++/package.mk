PKG_NAME="libsigc++"
PKG_VERSION="2.99.9"
PKG_SITE="http://libsigc.sourceforge.net"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.99/libsigc++-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain boost"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-documentation \
			      --with-gnu-ld \
			      --with-pic \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}