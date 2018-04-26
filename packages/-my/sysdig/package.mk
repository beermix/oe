PKG_NAME="sysdig"
PKG_VERSION="0.21.0"
PKG_URL="https://github.com/draios/sysdig/"
PKG_URL="https://github.com/draios/sysdig/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib ncurses openssl curl"
PKG_SECTION="debug"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DBUILD_DRIVER=ON \
			  -DBUILD_LIBSCAP_EXAMPLES=OFF \
			  -DENABLE_DKMS=OFF \
			  -DUSE_BUNDLED_CURL=OFF \
			  -DUSE_BUNDLED_NCURSES=OFF \
			  -DUSE_BUNDLED_OPENSSL=OFF \
			  -DUSE_BUNDLED_ZLIB=OFF"