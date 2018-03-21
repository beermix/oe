PKG_NAME="libvncserver"
PKG_VERSION="c49204c"
PKG_URL="https://github.com/LibVNC/libvncserver/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="x11"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-pic \
			      --with-gnu-ld \
			      --without-tightvnc-filetransfer \
			      --without-libva \
			      --with-pthread \
			      --without-crypto --without-ssl \
			      --without-gcrypt \
			      --without-gnutls \
			      --without-jpeg \
			      --without-png \
			      --without-zlib \
			      --without-websockets \
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