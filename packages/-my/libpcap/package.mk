PKG_NAME="libpcap"
PKG_VERSION="c980b57"
PKG_GIT_URL="https://github.com/the-tcpdump-group/libpcap"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_SECTION="devel"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF -DINET6=ON"