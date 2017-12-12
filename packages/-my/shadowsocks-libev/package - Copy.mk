PKG_NAME="shadowsocks-libev"
PKG_VERSION="git"
#PKG_URL="https://dl.dropboxusercontent.com/s/sx6vms5ihja38ma/shadowsocks-libev-3.0.8.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls c-ares"
PKG_SECTION="my"

PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"

LTO_SUPPORT="no"
GOLD_SUPPORT="no"

unpack() {
  git clone --recursive -v --depth 1 http://github.com/shadowsocks/shadowsocks-libev $PKG_BUILD
}

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
 # LIBS="$LIBS -pthread"
}

#PKG_CMAKE_SCRIPT="$PKG_BUILD/cmake/shadowsocks-libev.pc.cmake"

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