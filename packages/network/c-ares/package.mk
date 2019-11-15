PKG_NAME="c-ares"
PKG_VERSION="1.15.0"
PKG_SHA256="6cdb97871f2930530c97deb7cf5c8fa4be5a0b02c7cea6e7c7667672a39d6852"
PKG_SITE="https://github.com/c-ares/c-ares/releases"
PKG_URL="https://c-ares.haxx.se/download/c-ares-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="cmake-make"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DCARES_SHARED=OFF \
			  -DCARES_STATIC=ON \
			  -DCARES_BUILD_TOOLS=OFF"