PKG_NAME="c-ares"
PKG_VERSION="fd6124c"
PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCARES_SHARED=OFF -DCARES_STATIC=ON"

post_makeinstall_target() {
  rm -rf $INSTALL
}