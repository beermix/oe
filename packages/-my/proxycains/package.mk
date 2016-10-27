
PKG_NAME="proxychains"
PKG_VERSION="3.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="https://copy.com/6awndzFw4Zz0/proxychains-3.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="hiawatha"
PKG_LONGDESC="An advanced and secure webserver for Unix"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
}

make_target() {
./configure; make

}