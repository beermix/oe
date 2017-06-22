PKG_NAME="libproxy"
PKG_VERSION="0.4.15"
PKG_GIT_URL="https://github.com/libproxy/libproxy"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_SKIP_RPATH=ON \
			  -DPERL_VENDORINSTALL=yes \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DWITH_WEBKIT3=ON \
			  -DWITH_MOZJS=ON \
			  -DBIPR=0"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCARES_SHARED=0 -DCARES_STATIC=1"

post_makeinstall_target() {
  rm -rf $INSTALL
}
