PKG_NAME="zlib-ng"
PKG_VERSION="9992d3b"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_HOST=""
PKG_SECTION="compress"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

configure_host() {
  cmake -DCMAKE_INSTALL_PREFIX:PATH=$TOOLCHAIN \
  	 -DZLIB_COMPAT=1 \
  	 -DWITH_GZFILEOP=1 \
  	 -DWITH_OPTIM=1 \
        -DCMAKE_INSTALL_LIBDIR:PATH=lib \
  	 ..
}

PKG_CMAKE_OPTS_TARGET="-DZLIB_COMPAT=1 -DWITH_GZFILEOP=1 -DWITH_OPTIM=1 -DCC=$TARGET_CC"
