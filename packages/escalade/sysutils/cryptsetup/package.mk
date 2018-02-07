# Made by github.com/escalade
#
PKG_NAME="cryptsetup"
PKG_VERSION="2.0.0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://gitlab.com/cryptsetup/cryptsetup"
PKG_URL="https://www.kernel.org/pub/linux/utils/cryptsetup/v2.0/cryptsetup-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain lvm2 libgcrypt popt util-linux json-c"
PKG_SECTION="escalade"
PKG_SHORTDESC="Userspace setup tool for transparent encryption of block devices using dm-crypt"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-cryptsetup-reencrypt --with-libgcrypt-prefix=$SYSROOT_PREFIX/usr"
