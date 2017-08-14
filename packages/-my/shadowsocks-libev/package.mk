PKG_NAME="shadowsocks-libev"
PKG_VERSION="3.0.8"
#PKG_URL="https://dl.dropboxusercontent.com/s/sx6vms5ihja38ma/shadowsocks-libev-3.0.8.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcre libsodium libudns libev mbedtls"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

unpack() {
  git clone --recursive -v --depth 1 http://github.com/shadowsocks/shadowsocks-libev $PKG_BUILD
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

#pre_configure_target() {
#  export LIBS="$LIBS -pthread"
#}

#PKG_CMAKE_SCRIPT_TARGET="cmake/shadowsocks-libev.pc.cmake"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release \
			  -DWITH_DOC_HTML=0 \
			  -DWITH_DOC_MAN=0 \
			  -DWITH_STATIC=1 \
			  -DWITH_SS_REDIR=0"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-ssp \
			      --with-pcre=$SYSROOT_PREFIX/usr \
			      --disable-documentation"