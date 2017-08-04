PKG_NAME="miniupnpc"
PKG_VERSION="2.0.20170509"
PKG_SITE="http://miniupnp.free.fr"
PKG_URL="http://miniupnp.free.fr/files/miniupnpc-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DUPNPC_BUILD_SHARED=OFF -DUPNPC_BUILD_STATIC=ON"