PKG_NAME="libunistring"
PKG_VERSION="0.9.7"
PKG_SITE="https://ftp.gnu.org/gnu/libunistring/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/libunistring/libunistring-$PKG_VERSION.tar.xz"
PKG_BUILD_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
}
			   
