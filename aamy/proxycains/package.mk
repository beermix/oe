
PKG_NAME="proxychains"
PKG_VERSION="3.1"
PKG_URL="https://copy.com/6awndzFw4Zz0/proxychains-3.1.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="web"
PKG_SHORTDESC="hiawatha"
PKG_LONGDESC="An advanced and secure webserver for Unix"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

make_target() {
./configure; make

}