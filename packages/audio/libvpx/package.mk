PKG_NAME="libvpx"
PKG_VERSION="v1.6.1"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"


configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=/usr \
  		--cpu="ivybridge" \
  		--target=x86_64-linux-gcc \
  		--extra-cflags="$CFLAGS" \
  		--extra-cxxflags="$CXXFLAGS" \
  		--as=yasm \
  		--enable-multithread \
  		--disable-debug-libs \
  		--enable-libs \
  		--enable-thumb \
  		--enable-pic \
  		--disable-decode-perf-tests \
  		--disable-encode-perf-tests \
  		--disable-examples \
  		--disable-tools \
  		--disable-docs \
  		--enable-vp8 \
  		--enable-vp9 \
  		--enable-postproc \
  		--enable-vp9-postproc \
  		--enable-runtime-cpu-detect \
  		--enable-static \
  		--disable-shared
}

post_makeinstall_target() {
  rm -rf $INSTALL
}