PKG_NAME="libvpx"
PKG_VERSION="9a2dd7e"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

get_graphicdrivers

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./configure --prefix="/usr" \
  		--target="x86_64-linux-gcc" \
  		--libc="$(get_pkg_build glibc)" \
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
  		--enable-decode-perf-tests \
  		--enable-encode-perf-tests
}
