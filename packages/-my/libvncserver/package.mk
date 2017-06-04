PKG_NAME="libvncserver"
PKG_VERSION="master"
PKG_GIT_URL="https://github.com/LibVNC/libvncserver"
PKG_DEPENDS_TARGET="toolchain jpeg libpng"
PKG_SECTION="x11"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
			  -DWITH_IPv6=0 \
			  -DWITH_GNUTLS=0 \
			  -DWITH_OPENSSL=0 \
			  -DWITH_GCRYPT=0 \
			  -DWITH_24BPP=0 \
			  -DWITH_FFMPEG=0 \
			  -DWITH_WEBSOCKETS=0 \
			  -DWITH_TIGHTVNC_FILETRANSFER=0 \
			  -DCMAKE_BUILD_TYPE=Release"