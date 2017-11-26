PKG_NAME="libpcap"
PKG_VERSION="libpcap-1.8.1"
PKG_GIT_URL="https://github.com/the-tcpdump-group/libpcap"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_SECTION="devel"


PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF"

post_make_target() {
  cp libpcap.a $SYSROOT_PREFIX/usr/lib
}


makeinstall_target() {
  :
}