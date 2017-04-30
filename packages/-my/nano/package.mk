PKG_NAME="nano"
PKG_VERSION="2.8.1"
PKG_URL="https://www.nano-editor.org/dist/v2.8/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline file slang"
PKG_SECTION="shell/texteditor"
PKG_SHORTDESC="nano: Pico editor clone with enhancements"
PKG_LONGDESC="GNU nano (Nano's ANOther editor, or Not ANOther editor) is an enhanced clone of the Pico text editor."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.config/nano \
                           --datadir=/storage/.config/nano \
                           --libdir=/storage/.config/nano \
                           --libexecdir=/storage/.config/nano \
                           --sharedstatedir=/storage/.config/nano \
                           --localstatedir=/storage/.config/nano \
                           --includedir=/storage/.config/nano \
                           --oldincludedir=/storage/.config/nano \
                           --datarootdir=/storage/.config/nano \
                           --infodir=/storage/.config/nano \     
                           --localedir=/storage/.config/nano/locale \
                           --enable-threads=posix \
                           --enable-utf8 \
			      --enable-extra \
			      --disable-tiny \
			      --disable-speller \
			      --disable-justify \
			      --disable-tabcomp \
			      --enable-nanorc \
			      --disable-nls \
			      --disable-wrapping \
			      --with-slang=no \
			      --enable-color"

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}