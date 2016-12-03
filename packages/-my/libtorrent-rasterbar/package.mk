PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="69eff36"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl expat libiconv boost"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CMAKE_OPTS_TARGET="-Dunicode=ON -Dstatic_runtime=ON -Dshared=ON -Dlibiconv=ON"