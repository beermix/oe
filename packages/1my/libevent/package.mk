PKG_NAME="libevent"
PKG_VERSION="2.1.11-stable"
PKG_SHA256="229393ab2bf0dc94694f21836846b424f3532585bac3468738b7bf752c03901e"
PKG_SITE="https://github.com/libevent/libevent/releases"
PKG_URL="https://github.com/libevent/$PKG_NAME/archive/release-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_SHORTDESC="libevent: a library for asynchronous event notification"

PKG_CMAKE_OPTS_TARGET="-DEVENT__DISABLE_BENCHMARK=ON \
			  -DEVENT__DISABLE_DEBUG_MODE=ON \
			  -DEVENT__DISABLE_REGRESS=ON \
			  -DEVENT__DISABLE_SAMPLES=ON \
			  -DEVENT__DISABLE_TESTS=ON \
			  -DEVENT__DISABLE_OPENSSL=OFF \
			  -DBUILD_TESTING=OFF \
			  -DEVENT__LIBRARY_TYPE=STATIC"