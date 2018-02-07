PKG_NAME="libvpx"
PKG_VERSION="c8f6e7b"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"


pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  
  get_graphicdrivers
  
  strip_lto
  strip_gold
}

configure_target() {
  ./configure --prefix="/usr" \
  		--target="x86_64-linux-gcc" \
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



unpac_target() {
  ./configure --prefix="/usr" \
  		--as=yasm \
  		--enable-pic \
  		--enable-runtime-cpu-detect \
  		--disable-shared \
  		--enable-pic \
  		--disable-install-docs \
  		--disable-install-srcs \
  		--enable-vp8 \
  		--enable-postproc \
  		--enable-vp9 \
  		--enable-vp9-highbitdepth \
  		--enable-experimental \
  		--enable-spatial-svc \
  		--disable-encode-perf-tests \
  		--disable-decode-perf-tests \
  		--disable-decode-perf-tests \
  		--disable-encode-perf-tests \
  		--disable-unit-tests \
  		--disable-examples \
  		--disable-debug-libs \
  		--disable-docs
}