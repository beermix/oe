PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="libtorrent-1_0_11"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="yes"




CFLAGS="-O3 -pipe -fstack-protector-strong"
CPPFLAGS="-D_FORTIFY_SOURCE=2"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed"

PKG_CMAKE_OPTS_TARGET="-Dshared=OFF \
			  -Ddeprecated-functions=OFF \
			  -DOPENSSL_CRYPTO_LIBRARY=$SYSROOT_PREFIX/usr/lib/libcrypto.a \
			  -DOPENSSL_SSL_LIBRARY=$SYSROOT_PREFIX/usr/lib/libssl.a \
			  -DPKG_CONFIG_EXECUTABLE=$TOOLCHAIN/bin/pkg-config \
			  -DCMAKE_VERBOSE_MAKEFILE=TRUE"
			      
			      