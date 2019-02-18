PKG_NAME="libmbim"
PKG_VERSION="1.12.4"
PKG_URL="https://www.freedesktop.org/software/libmbim/libmbim-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python swig:host"

PKG_SECTION="devel"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"