PKG_NAME="transmission"
PKG_VERSION="c199eef"
PKG_GIT_URL="https://github.com/transmission/transmission"
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl miniupnpc libdaemon"
PKG_AUTORECONF="no"

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=ON -DENABLE_LIGHTWEIGHT=ON"