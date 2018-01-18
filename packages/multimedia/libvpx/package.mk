PKG_NAME="libvpx"
PKG_VERSION="373e08f"
PKG_URL="https://github.com/webmproject/libvpx/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"

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
