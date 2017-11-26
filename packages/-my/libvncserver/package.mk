PKG_NAME="libvncserver"
PKG_VERSION="6814e94"
PKG_GIT_URL="https://github.com/LibVNC/libvncserver"
PKG_DEPENDS_TARGET="toolchain libpng"
PKG_SECTION="x11"

PKG_USE_CMAKE="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-pic \
			      --with-gnu-ld \
			      --without-tightvnc-filetransfer \
			      --without-websockets \
			      --without-crypt \
			      --without-crypto \
			      --without-ssl \
			      --without-gcrypt \
			      --without-gnutls \
			      --without-ipv6"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=off \
			  -DWITH_IPv6=off \
			  -DWITH_GNUTLS=off \
			  -DWITH_OPENSSL=off \
			  -DWITH_GNUTLS=off \
			  -DWITH_GCRYPT=off \
			  -DWITH_24BPP=on \
			  -DWITH_PNG=off \
			  -DWITH_FFMPEG=off \
			  -DWITH_WEBSOCKETS=off \
			  -DWITH_TIGHTVNC_FILETRANSFER=off \
			  -DCMAKE_BUILD_TYPE=Release"