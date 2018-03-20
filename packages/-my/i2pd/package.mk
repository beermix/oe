PKG_NAME="i2pd"
PKG_VERSION="b1a6c5d"
PKG_URL="https://github.com/PurpleI2P/i2pd/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain boost zlib miniupnpc openssl"
PKG_SECTION="my"
PKG_TOOLCHAIN="make"
			  
make_target() {
  cd $PKG_BUILD
  make USE_STATIC=no USE_AESNI=no USE_AVX=no USE_UPNP=no \
  	CC="$CC" \
  	CXX="$CXX -lpthread -fno-omit-frame-pointer -ffunction-sections -fdata-sections" \
  	LDFLAGS="$LDFLAGS -latomic -Wl,--gc-sections" \
  	RANLIB="$RANLIB" \
  	AR="$AR"
}

post_make_target() {
  $STRIP --strip-all $PKG_BUILD/i2pd
}