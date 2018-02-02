PKG_NAME="libav"
PKG_VERSION="12.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_GIT_URL="https://github.com/libav/libav"
PKG_GIT_BRANCH="release/12"
PKG_DEPENDS_TARGET="toolchain ffmpeg"
PKG_SECTION="my"

get_graphicdrivers

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto
  strip_gold
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
              --host-libs="-lm" \
              --extra-cflags="$CFLAGS" \
              --extra-ldflags="$LDFLAGS" \
              --extra-libs="$FFMPEG_LIBS" \
              --enable-static \
              --disable-shared \
              --enable-gpl \
              --disable-version3 \
              --enable-nonfree \
              --enable-logging \
              --disable-doc \
              --enable-pic \
              --pkg-config="$TOOLCHAIN/bin/pkg-config" \
              --enable-optimizations \
              --enable-yasm
}

makeinstall_target() {
  : # nop
}
