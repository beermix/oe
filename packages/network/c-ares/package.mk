PKG_NAME="c-ares"
PKG_VERSION="cares-1_13_0"
PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DCARES_SHARED=0 -DCARES_STATIC=1"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCARES_SHARED=0 -DCARES_STATIC=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}
