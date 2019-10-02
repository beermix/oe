PKG_NAME="libunistring"
PKG_VERSION="0.9.10"
PKG_SITE="https://ftp.gnu.org/gnu/libunistring/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/libunistring/libunistring-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_DEPENDS_HOST="intltool:host"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
