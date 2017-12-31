PKG_NAME="joe"
PKG_VERSION="4.2"
PKG_URL="https://master.dl.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.2/joe-4.2.tar.gz"
PKG_SOURCE_DIR="$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain readline file"

PKG_SECTION="shell/texteditor"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LDFLAGS="-lcurses -lterminfo"
  export LIBS="-lcurses -lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-silent-rules \
			   --enable-static \
			   --disable-nls"