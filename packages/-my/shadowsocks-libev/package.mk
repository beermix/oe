PKG_NAME="shadowsocks-libev"
PKG_VERSION="3.1.0"
PKG_URL="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.1.0/shadowsocks-libev-3.1.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libev mbedtls c-ares"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

LTO_SUPPORT="no"
GOLD_SUPPORT="no"

PKG_CMAKE_SCRIPT_TARGET="cmake/shadowsocks-libev.pc.cmake"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DWITH_DOC_HTML=OFF \
			  -DWITH_DOC_MAN=OFF \
			  -DWITH_STATIC=ON \
			  -DWITH_SS_REDIR=OFF"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --with-pcre=$SYSROOT_PREFIX/usr \
			      --disable-documentation"