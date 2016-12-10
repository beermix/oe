PKG_NAME="transmission"
PKG_VERSION="9d562ab"
PKG_GIT_URL="https://github.com/transmission/transmission"
PKG_DEPENDS_TARGET="toolchain zlib openssl libpcap pcre libevent curl miniupnpc libdaemon"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DWITH_CRYPTO=openssl \
			  -DWITH_INOTIFY=OFF \
			  -DWITH_KQUEUE=OFF \
			  -DHAVE_XFS_XFS_H=0 \
			  -DWITH_SYSTEMD=ON \
			  -DINSTALL_LIB=OFF \
			  -DINSTALL_DOC=OFF \
			  -DENABLE_UTP=ON \
			  -DENABLE_TESTS=OFF \
			  -DENABLE_QT=OFF \
			  -DENABLE_GTK=OFF \
			  -DENABLE_DAEMON=ON \
			  -DENABLE_CLI=OFF \
			  -DUSE_SYSTEM_EVENT2=YES \
			  -DUSE_SYSTEM_MINIUPNPC=YES \
			  -DUSE_SYSTEM_NATPMP=NO \
			  -DUSE_SYSTEM_DHT=OFF 
			  -DUSE_SYSTEM_B64=NO \
			  -DUSE_SYSTEM_UTP=NO \
			  -DENABLE_LIGHTWEIGHT=OFF"