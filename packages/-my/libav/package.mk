PKG_NAME="libav"
PKG_VERSION="release.11-2c0dfc2"
PKG_URL="https://git.libav.org/?p=libav.git;a=snapshot;h=refs/heads/release/11;sf=tgz"
PKG_SOURCE_DIR="aufs2-util"
PKG_BUILD_DEPENDS_TARGET="toolchain openssl libsodium libevent"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

configure_target() {
  cd $ROOT/$PKG_BUILD
  strip_lto
./configure --enable-static --disable-shared --disable-lto --enable-mmx --enable-sse --enable-ssse3 --enable-sse4 --enable-avx --enable-yasm --enable-nonfree --enable-small --enable-gpl --enable-vaapi --disable-debug --enable-extra-warnings --cpu=ivybridge --enable-x11grab --enable-openssl --disable-doc 
}
