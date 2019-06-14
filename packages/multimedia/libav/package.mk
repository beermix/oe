PKG_NAME="libav"
PKG_VERSION="56f5018"
PKG_URL="https://github.com/libav/libav/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg freetype openssl"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-gold -lto"

get_graphicdrivers

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./configure --prefix="/usr" \
              --cpu="$TARGET_CPU" \
              --arch="$TARGET_ARCH" \
              --enable-cross-compile \
              --cross-prefix="$TARGET_PREFIX" \
              --sysroot="$SYSROOT_PREFIX" \
              --sysinclude="$SYSROOT_PREFIX/usr/include" \
              --target-os="linux" \
              --nm="$NM" \
              --ar="$AR" \
              --as="$CC" \
              --cc="$CC" \
              --ld="$CC" \
              --host-cc="$HOST_CC" \
              --host-cflags="$HOST_CFLAGS" \
              --host-ldflags="$HOST_LDFLAGS" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS" \
              --extra-libs="$FFMPEG_LIBS" \
              --enable-static \
              --disable-shared \
              --disable-logging \
              --disable-doc \
              --disable-debug \
              --enable-gpl \
              --enable-nonfree \
              --enable-pic \
              --pkg-config="$TOOLCHAIN/bin/pkg-config" \
              --enable-optimizations \
              --enable-x86asm
}

makeinstall_target() {
  : # nop
}

make_target() {
  make
}

