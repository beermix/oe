PKG_NAME="i2pd"
PKG_VERSION="90"
PKG_URL="https://dl.dropboxusercontent.com/s/qfsu9bwzbpm41oe/i2pd-90.tar.bz2"
PKG_DEPENDS_TARGET="toolchain boost zlib libressl miniupnpc"

PKG_SECTION="my"



configure_target() {
  git pull
  cd build
  strip_lto
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_LIBRARY=OFF \
        -DWITH_PCH=OFF \
        -DWITH_MESHNET=OFF \
  	-DWITH_STATIC=OFF \
  	-DWITH_UPNP=ON \
  	-DTHREADS_PTHREAD_ARG=4 \
  	-DWITH_HARDENING=OFF \
  	-DWITH_AESNI=ON \
  	.
}

post_makeinstall_target() {
 rm -rf $INSTALL/usr/src/
 rm  $INSTALL/usr/LICENSE
}