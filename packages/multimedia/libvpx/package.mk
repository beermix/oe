PKG_NAME="libvpx"
PKG_VERSION="5bc4c37"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

get_graphicdrivers

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  ./configure --prefix="/usr" \
  		--as=yasm \
  		--enable-pic \
  		--enable-runtime-cpu-detect \
  		--enable-shared \
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
