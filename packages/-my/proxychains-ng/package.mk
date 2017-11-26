PKG_NAME="proxychains-ng"
PKG_VERSION="bb3df1e"
PKG_GIT_URL="https://github.com/rofl0r/proxychains-ng"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl curl"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"



#post_makeinstall_target() {
#  rm -rf $INSTALL/storage/
#}
