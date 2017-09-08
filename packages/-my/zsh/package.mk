PKG_NAME="zsh"
PKG_VERSION="5.4.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

LTO_SUPPORT="yes"

pre_configure_target() {
  export LIBS="$LIBS -lncursesw -ltinfo"
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-multibyte \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-pcre \
			      --enable-cap \
			      --enable-zsh-secure-free"