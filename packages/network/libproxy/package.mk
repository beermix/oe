PKG_NAME="libproxy"
PKG_VERSION="0.4.15"
PKG_GIT_URL="https://github.com/libproxy/libproxy"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCARES_SHARED=0 -DCARES_STATIC=1"

PKG_CMAKE_OPTS_HOST="-DCARES_SHARED=0 -DCARES_STATIC=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}
