PKG_NAME="gdbm"
PKG_VERSION="1.12"
PKG_URL="ftp://ftp.gnu.org/gnu/gdbm/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --disable-nls \
			   --with-gdbm183-library \
			   --enable-libgdbm-compat \
			   --with-sysroot=$SYSROOT_PREFIX"
			   
#--enable-libgdbm-compat