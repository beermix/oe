PKG_NAME="transmission"
PKG_VERSION="c199eef"
PKG_GIT_URL="https://github.com/transmission/transmission"
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl miniupnpc libdaemon"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DWITH_SYSTEMD=ON \
			  -DINSTALL_LIB=OFF \
			  -DINSTALL_DOC=OFF \
			  -DENABLE_TESTS=OFF \
			  -DENABLE_UTP=ON \
			  -DENABLE_DAEMON=ON \
			  -DENABLE_CLI=ON \
			  -DUSE_SYSTEM_MINIUPNPC=YES \
			  -DENABLE_LIGHTWEIGHT=OFF"