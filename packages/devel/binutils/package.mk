PKG_NAME="binutils"
PKG_VERSION="2.26.1"
PKG_URL="http://192.168.1.2:8887/binutils-2.26.1.tar.bz2"
PKG_DEPENDS_HOST="ccache:host bison:host flex:host linux:host texinfo:host"
PKG_SECTION="toolchain/devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME \
                         --with-sysroot=$SYSROOT_PREFIX \
                         --with-lib-path=$SYSROOT_PREFIX/lib:$SYSROOT_PREFIX/usr/lib \
                         --without-ppl \
                         --without-cloog \
                         --disable-werror \
                         --disable-multilib \
                         --disable-libada \
                         --disable-libssp \
                         --enable-version-specific-runtime-libs \
                         --enable-plugins \
                         --enable-gold \
                         --enable-ld=default \
                         --enable-lto \
                         --disable-nls \
                         --enable-static \
                         --disable-shared \
                         --disable-gdb \
                         --disable-sim \
                         --with-system-zlib \
                         --enable-poison-system-directories"

makeinstall_host() {
  cp -v ../include/libiberty.h $SYSROOT_PREFIX/usr/include
  make install
}