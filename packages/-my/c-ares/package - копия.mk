PKG_NAME="c-ares"
PKG_VERSION="1.12.0"
PKG_URL="https://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
#PKG_VERSION="cares-1_12_0"
#PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCARES_SHARED=OFF -DCARES_STATIC=ON"

post_makeinstall_target() {
  rm -rf $INSTALL
}