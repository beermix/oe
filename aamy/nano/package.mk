PKG_NAME="nano"
PKG_VERSION="3.2"
PKG_URL="https://www.nano-editor.org/dist/v3/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"

PKG_CONFIGURE_OPTS_TARGET="--enable-color --disable-libmagic --enable-utf8 --sysconfdir=/storage/.config/nano --datarootdir=/storage/.config/nano"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}