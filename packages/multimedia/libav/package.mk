PKG_NAME="libav"
PKG_VERSION="v12"
PKG_GIT_URL="https://github.com/libav/libav"
PKG_DEPENDS_TARGET="toolchain"
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
              --host-cppflags="$HOST_CPPFLAGS -D_DEFAULT_SOURCE" \
              --host-ldflags="$HOST_LDFLAGS -fPIC" \
              --host-libs="-lm" \
              --extra-ldflags="$LDFLAGS -fPIC" \
              --extra-ldflags="$LDFLAGS" \
              --pkg-config="$ROOT/$TOOLCHAIN/bin/pkg-config" \
              --enable-thumb \
              --disable-vdpau \
              --disable-doc \
              --enable-static \
              --disable-shared \
              --enable-pic \
              --disable-lto \
              --disable-debug \
              --enable-nonfree \
              --enable-openssl
}
