PKG_NAME="nano"
PKG_VERSION="4.3"
PKG_SHA256="00d3ad1a287a85b4bf83e5f06cedd0a9f880413682bebd52b4b1e2af8cfc0d81"
PKG_URL="https://ftp.gnu.org/gnu/nano/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"

PKG_CONFIGURE_OPTS_TARGET="--enable-color --disable-libmagic --enable-utf8 --sysconfdir=/storage/.config/nano --datarootdir=/storage/.config/nano"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}