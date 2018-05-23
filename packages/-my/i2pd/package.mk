PKG_NAME="i2pd"
PKG_VERSION="2.18.0"
PKG_URL="https://github.com/PurpleI2P/i2pd/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl"
PKG_SECTION="my"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_SCRIPT="$PKG_BUILD/build/CMakeLists.txt"

PKG_CMAKE_OPTS_TARGET="-DWITH_LIBRARY=OFF \
			  -DWITH_PCH=OFF \
			  -DWITH_MESHNET=OFF \
			  -DWITH_STATIC=OFF \
			  -DWITH_UPNP=OFF \
			  -DWITH_HARDENING=OFF \
			  -DWITH_AESNI=OFF"

post_makeinstall_target() {
 rm -rf $INSTALL/usr/src/
 rm  $INSTALL/usr/LICENSE
}