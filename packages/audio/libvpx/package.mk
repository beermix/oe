PKG_NAME="libvpx"
PKG_VERSION="v1.6.1"
PKG_GIT_URL="https://github.com/webmproject/libvpx/"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  ./configure --prefix=/usr \
  		--target=x86_64-linux-gcc \
  		--libc=$(get_pkg_build glibc) \
  		--cpu=ivybridge \
  		--as=yasm \
  		--disable-debug-libs \
  		--enable-pic \
  		--enable-vp8 \
  		--enable-vp9 \
  		--enable-postproc \
  		--enable-spatial-svc \
  		--enable-vp9-highbitdepth \
  		--disable-decode-perf-tests \
  		--disable-encode-perf-tests \
  		--disable-examples \
  		--disable-tools \
  		--disable-docs \
  		--enable-runtime-cpu-detect \
  		--enable-static \
  		--disable-shared
}

post_makeinstall_target() {
  rm -rf $INSTALL
  #make test V=s
}
