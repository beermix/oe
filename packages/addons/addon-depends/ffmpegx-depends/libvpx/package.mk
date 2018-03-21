PKG_NAME="libvpx"
PKG_VERSION="1.7.0"
PKG_URL="https://github.com/webmproject/libvpx/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  
  get_graphicdrivers
}

configure_target() {
  ./configure --prefix="/usr" \
  		--target="x86_64-linux-gcc" \
  		--extra-cflags="$CFLAGS -fPIC" \
  		--cpu="$TARGET_CPU" \
  		--as=yasm \
  		--enable-pic \
  		--enable-vp8 \
  		--enable-vp9 \
  		--enable-postproc \
  		--enable-vp9-postproc \
  		--enable-vp9-temporal-denoising \
  		--enable-libyuv \
  		--enable-vp9-highbitdepth \
  		--disable-encode-perf-tests \
  		--disable-decode-perf-tests \
  		--disable-unit-tests \
  		--disable-examples \
  		--disable-debug-libs \
  		--disable-docs \
  		--disable-install-docs \
  		--enable-runtime-cpu-detect \
  		--disable-shared \
  		--disable-decode-perf-tests \
  		--disable-encode-perf-tests
}
