PKG_NAME="gccgo"
PKG_VERSION="master"
PKG_URL="https://github.com/gcc-mirror/gcc/archive/gccgo.zip"
PKG_SOURCE_DIR="gcc-gccgo"
PKG_DEPENDS_TARGET=""

PKG_SECTION="devel"

PKG_TOOLCHAIN="autotools"

pre_configure_host() {
  export CXXFLAGS="$CXXFLAGS -std=gnu++98"
}

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-gmp=$TOOLCHAIN \
                         --with-mpfr=$TOOLCHAIN \
                         --with-mpc=$TOOLCHAIN \
                         --without-ppl \
                         --without-cloog \
                         --enable-languages=go \
                         --with-gnu-as \
                         --with-gnu-ld \
                         --enable-__cxa_atexit \
                         --disable-libada \
                         --enable-decimal-float \
                         --disable-libmudflap \
                         --disable-libssp \
                         --disable-multilib \
                         --disable-libatomic \
                         --disable-libitm \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-plugin \
                         --enable-lto \
                         --disable-libquadmath \
                         --disable-libgomp \
                         --enable-tls \
                         --with-system-zlib \
                         --with-tune=generic -v \
                         --enable-shared \
                         --disable-static \
                         --enable-c99 \
                         --enable-long-long \
                         --enable-threads=posix \
                         --disable-libstdcxx-pch \
                         --enable-libstdcxx-time \
                         --enable-clocale=gnu \
                         $GCC_OPTS \
                         --disable-nls \
                         --enable-checking=release \
                         --with-default-libstdcxx-abi=gcc4-compatible"