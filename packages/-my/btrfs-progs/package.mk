PKG_NAME="btrfs-progs"
PKG_VERSION="v4.7.1"
PKG_URL="https://github.com/kdave/btrfs-progs/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="btrfs-progs-4.7.1"
PKG_DEPENDS_TARGET="toolchain util-linux zlib lzo e2fsprogs e2fsprogs"
PKG_DEPENDS_INIT="toolchain util-linux zlib lzo e2fsprogs"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--exec-prefix=/ \
                           --bindir=/sbin \
                           --disable-documentation \
                           --disable-convert \
                           --enable-static \
                           --disable-shared"

pre_configure_target() {
  ./autogen.sh
}


PKG_CONFIGURE_OPTS_INIT="--exec-prefix=/ \
                           --bindir=/sbin \
                           --disable-documentation \
                           --disable-convert \
                           --enable-static \
                           --disable-shared"

pre_configure_init() {
  ./autogen.sh
}
