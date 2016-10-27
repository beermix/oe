PKG_NAME="proxychains-ng"
PKG_VERSION="635ded3"
PKG_URL="https://github.com/rofl0r/proxychains-ng/archive/$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl curl"
PKG_PRIORITY="optional"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}
CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --sysconfdir=/storage/.config/proxychains-ng --fat-binary --enable-static --disable-shared"



#post_makeinstall_target() {
#  rm -rf $INSTALL/storage/
#}
