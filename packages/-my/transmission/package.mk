PKG_NAME="transmission"
PKG_VERSION="f48c0cc"
PKG_GIT_URL="https://github.com/transmission/transmission"
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl miniupnpc libdaemon"
PKG_AUTORECONF="no"

CONCURRENCY_MAKE_LEVEL=1
strip_lto

PKG_CMAKE_OPTS_TARGET="-DWITH_SYSTEMD=ON \
			  -DINSTALL_LIB=OFF \
			  -DCMAKE_C_FLAGS="$CFLAGS" \
			  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
			  -DINSTALL_DOC=OFF \
			  -DENABLE_TESTS=OFF \
			  -DENABLE_UTP=ON \
			  -DENABLE_DAEMON=ON \
			  -DENABLE_CLI=OFF \
			  -DUSE_SYSTEM_MINIUPNPC=YES \
			  -DENABLE_LIGHTWEIGHT=OFF"