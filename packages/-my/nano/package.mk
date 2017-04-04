PKG_NAME="nano"
PKG_VERSION="2.8.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"
PKG_LONGDESC="GNU nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone of the Pico text editor."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
			      --enable-extra \
			      --enable-libmagic \
			      --with-wordbounds \
			      --infodir=/storage/.config \
			      --disable-help \
			      --disable-tiny \
			      --disable-silent-rules \
			      --enable-color \
			      --disable-wrapping-as-root \
			      --disable-speller \
			      --disable-justify \
			      --disable-tabcomp \
			      --disable-wrapping \
			      --without-slang \
			      --sysconfdir=/storage/.config/nano"

post_makeinstall_target() {
  #rm -rf $INSTALL/usr/bin/rnano
  rm -rf $INSTALL/storage
}