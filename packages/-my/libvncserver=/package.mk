PKG_NAME="libvncserver"
PKG_VERSION="c49204c"
PKG_URL="https://github.com/LibVNC/libvncserver/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="x11"
PKG_TOOLCHAIN="cmake-make"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-pic \
			      --with-gnu-ld \
			      --without-tightvnc-filetransfer \
			      --without-libva \
			      --without-crypto --without-ssl \
			      --without-gcrypt \
			      --without-gnutls \
			      --without-jpeg \
			      --without-png \
			      --without-zlib \
			      --without-ipv6"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=0 \
			  -DWITH_IPv6=0 \
			  -DWITH_GNUTLS=0 \
			  -DWITH_OPENSSL=0 \
			  -DWITH_GNUTLS=0 \
			  -DWITH_GCRYPT=0 \
			  -DWITH_24BPP=0 \
			  -DWITH_PNG=0 \
			  -DWITH_FFMPEG=0 \
			  -DWITH_WEBSOCKETS=0 \
			  -DWITH_TIGHTVNC_FILETRANSFER=0"