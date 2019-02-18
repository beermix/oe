PKG_NAME="libsigc++"
PKG_VERSION="2.99.10"
PKG_SITE="http://libsigc.sourceforge.net"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.99/libsigc++-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-documentation \
			      --with-gnu-ld \
			      --with-pic"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}