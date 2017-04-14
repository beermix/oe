PKG_NAME="libav"
PKG_VERSION="03fb0f7"
PKG_GIT_URL="https://github.com/libav/libav"
PKG_DEPENDS_TARGET="toolchain libvpx"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  strip_lto
  strip_gold
}

configure_target() {
  ./configure --prefix=/usr \
              --cpu=$TARGET_CPU \
              --arch=$TARGET_ARCH \
              --enable-cross-compile \
              --cross-prefix=${TARGET_NAME}- \
              --sysroot=$SYSROOT_PREFIX \
              --sysinclude="$SYSROOT_PREFIX/usr/include" \
              --target-os="linux" \
              --extra-version="$PKG_VERSION" \
              --nm="$NM" \
              --ar="$AR" \
              --as="$CC" \
              --cc="$CC" \
              --ld="$CC" \
              --host-cc="$HOST_CC" \
              --host-cflags="$HOST_CFLAGS -fPIC" \
              --host-ldflags="$HOST_LDFLAGS -fPIC" \
              --host-libs="-lm" \
              --extra-ldflags="$LDFLAGS -fPIC" \
              --extra-ldflags="$LDFLAGS" \
              --pkg-config="$ROOT/$TOOLCHAIN/bin/pkg-config" \
              --enable-thumb \
              --disable-vdpau \
              --disable-doc \
              --disable-static \
              --enable-shared \
              --enable-pic \
              --disable-lto \
              --disable-debug \
              --enable-nonfree \
              --enable-libvpx \
              --enable-openssl
}
