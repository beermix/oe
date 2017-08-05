PKG_NAME="transmission"
PKG_VERSION="2.92"
PKG_SITE="https://github.com/transmission/transmission-releases"
PKG_URL="https://github.com/transmission/transmission-releases/raw/master/transmission-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl curl miniupnpc xfsprogs-dev"
PKG_SECTION="my"
PKG_IS_ADDON="no"

PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

#unpack() {
#  git clone --recursive -v --depth 1 https://github.com/transmission/transmission $PKG_BUILD
#}

PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=OFF \
                       -DENABLE_DAEMON=ON \
                       -DENABLE_GTK=OFF \
                       -DENABLE_QT=ON \
                       -DENABLE_TESTS=OFF \
                       -DENABLE_UTILS=OFF \
                       -DENABLE_LIGHTWEIGHT=OFF \
                       -DINSTALL_DOC=OFF \
                       -DINSTALL_LIB=OFF \
                       -DUSE_SYSTEM_B64=OFF \
                       -DUSE_SYSTEM_DHT=OFF \
                       -DUSE_SYSTEM_EVENT2=OFF \
                       -DUSE_SYSTEM_MINIUPNPC=OFF \
                       -DUSE_SYSTEM_NATPMP=OFF \
                       -DUSE_SYSTEM_UTP=OFF \
                       -DWITH_SYSTEMD=ON"