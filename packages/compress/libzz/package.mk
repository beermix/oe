PKG_NAME="libzz"
PKG_VERSION="2015.12.26"
PKG_URL="https://dl.dropboxusercontent.com/s/luq5cd912w8s420/libzz-2015.12.26.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST=""

PKG_SECTION="compress"



TARGET_CONFIGURE_OPTS="--prefix=/usr"
HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN"

pre_configure_host() {
# clean host cflags and use libz's own
  CFLAGS=""
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

post_makeinstall_host() {
  rm -rf $TOOLCHAIN/lib/libz.so*
}