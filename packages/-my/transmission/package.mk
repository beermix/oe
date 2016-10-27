PKG_NAME="transmission"
PKG_VERSION="0390684"
PKG_GIT_URL="https://github.com/transmission/transmission"
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl miniupnpc libdaemon"
PKG_PRIORITY="optional"
PKG_SECTION="service/downloadmanager"
PKG_ADDON_TYPE="kodi.service" ## -DHAVE_XFS_XFS_H=1 -DCMAKE_BUILD_TYPE=Release
PKG_AUTORECONF="no"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_CMAKE_OPTS_TARGET="-DWITH_CRYPTO=openssl \
		       -DWITH_INOTIFY=OFF \
		       -DWITH_KQUEUE=OFF \
		       -DWITH_SYSTEMD=ON \
		       -DINSTALL_LIB=ON \
		       -DINSTALL_DOC=OFF \
		       -DENABLE_UTP=ON \
		       -DENABLE_TESTS=OFF \
		       -DENABLE_QT=OFF \
		       -DENABLE_GTK=OFF \
		       -DENABLE_DAEMON=ON \
		       -DENABLE_CLI=OFF \
		       -DHAVE_XFS_XFS_H=0 \
		       -DUSE_SYSTEM_EVENT2=YES \
		       -DUSE_SYSTEM_MINIUPNPC=YES \
		       -DUSE_SYSTEM_NATPMP=NO \
		       -DUSE_SYSTEM_DHT=OFF \
		       -DUSE_SYSTEM_B64=NO \
		       -DUSE_SYSTEM_UTP=NO \
		       -DENABLE_LIGHTWEIGHT=OFF"