PKG_NAME="nano"
PKG_VERSION="2.7.3"
PKG_URL="https://www.nano-editor.org/dist/v2.7/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file sed"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"
PKG_LONGDESC="GNU nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone of the Pico text editor."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
                           --sysconfdir=/storage/.config/nano \
                           --disable-wrapping-as-root \
			      --without-slang \
			      --enable-color"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}