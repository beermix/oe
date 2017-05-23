PKG_NAME="shadowsocks-libev"
PKG_VERSION="git"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

unpack() {
  git clone --recursive -v --depth 1 http://github.com/shadowsocks/shadowsocks-libev $PKG_BUILD
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}



#PKG_CMAKE_SCRIPT_TARGET="cmake/shadowsocks-libev.pc.cmake"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --disable-documentation"