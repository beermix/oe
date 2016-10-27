PKG_NAME="open-ath9k-htc-firmware"
PKG_VERSION="f43f19c"
PKG_URL="https://github.com/qca/open-ath9k-htc-firmware/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libevent openssl"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="no"


configure_target() {
  cd target_firmware
  unset CFLAGS
  unset CPPFLAGS
  unset CXXFLAGS
  unset LDFLAGS
  cmake -DCMAKE_INSTALL_PREFIX=/usr
}