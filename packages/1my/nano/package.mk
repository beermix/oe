PKG_NAME="nano"
PKG_VERSION="4.4"
PKG_SHA256="2af222e0354848ffaa3af31b5cd0a77917e9cb7742cd073d762f3c32f0f582c7"
PKG_URL="https://ftp.gnu.org/gnu/nano/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"

PKG_CONFIGURE_OPTS_TARGET="--enable-color --disable-libmagic --enable-utf8 --sysconfdir=/storage/.config/nano --datarootdir=/storage/.config/nano"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}