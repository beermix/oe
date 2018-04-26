PKG_NAME="sysdig"
PKG_VERSION="0.21.0"
PKG_URL="https://github.com/draios/sysdig/"
PKG_URL="https://github.com/draios/sysdig/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib ncurses openssl curl"
PKG_SECTION="debug"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="-lto -gold -hardening"

PKG_CMAKE_OPTS_TARGET="-DBUILD_DRIVER=0 \
			  -DBUILD_LIBSCAP_EXAMPLES=0 \
			  -DENABLE_DKMS=0 \
			  -DUSE_BUNDLED_CURL=1 \
			  -DUSE_BUNDLED_NCURSES=1 \
			  -DUSE_BUNDLED_OPENSSL=1 \
			  -DUSE_BUNDLED_ZLIB=1"