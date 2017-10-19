# Made by github.com/escalade

PKG_NAME="tinyalsa"
PKG_VERSION="1.1.1"
PKG_ARCH="any"
PKG_LICENSE="AOSP"
PKG_SITE="https://github.com/tinyalsa/tinyalsa"
PKG_GIT_URL="https://github.com/tinyalsa/tinyalsa"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="escalade/drivers"
PKG_SHORTDESC="TinyALSA is a small library to interface with ALSA in the Linux kernel."


PKG_AUTORECONF="no"

make_target() {
  make CC=$CC LD=$CC AR=$AR
}
