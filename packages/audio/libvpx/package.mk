PKG_NAME="libvpx"
PKG_VERSION="v1.6.1"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-m64||g"`
}

configure_target() {
  ./configure --prefix="/usr" \
  		--target="x86_64-linux-gcc" \
  		--libc="$(get_pkg_build glibc)" \
  		--cpu="corei7" \
  		--extra-cflags="$CFLAGS" \
  		--extra-cxxflags="$CXXFLAGS" \
  		--as=yasm \
  		--enable-vp8 \
  		--enable-vp9 \
  		--enable-postproc \
  		--enable-vp9-postproc \
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