PKG_NAME="nano"
PKG_VERSION="2.8.0"
PKG_URL="https://www.nano-editor.org/dist/v2.8/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file slang"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"
PKG_LONGDESC="GNU nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone of the Pico text editor."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
			      --enable-extra \
			      --enable-libmagic \
			      --with-wordbounds \
			      --disable-help \
			      --disable-tiny \
			      --enable-silent-rules \
			      --enable-color \
			      --disable-wrapping-as-root \
			      --with-slang \
			      --sysconfdir=/storage/.config/nano \
			      --infodir=/storage/.config"

post_makeinstall_target() {
  #rm -rf $INSTALL/usr/bin/rnano
  rm -rf $INSTALL/storage
}