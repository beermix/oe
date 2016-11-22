PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_ARCH="any"
PKG_URL="https://www.libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz mbedtls"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="yes"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CMAKE_OPTS_TARGET="-DBUILD_EXAMPLES=OFF \
		       -DBUILD_SHARED_LIBS=OFF \
		       -DBUILD_TESTING=OFF \
		       -DCRYPTO_BACKEND="mbedTLS" \
		       -DENABLE_GEX_NEW=OFF \
		       -DENABLE_ZLIB_COMPRESSION=OFF \
		       -DENABLE_MAC_NONE=ON \
		       -DENABLE_CRYPT_NONE=ON"


#pre_configure_target() {
#  #strip_lto
#  #strip_gold
#  export LIBS="-lterminfo"
#  export CFLAGS="$CFLAGS -fPIC -DPIC"
#  export CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
#}