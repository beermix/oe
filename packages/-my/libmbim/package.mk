PKG_NAME="libmbim"
PKG_VERSION="1.12.4"
PKG_URL="https://www.freedesktop.org/software/libmbim/libmbim-1.12.4.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python swig:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --with-gnu-ld"