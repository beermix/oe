PKG_NAME="zsh"
PKG_VERSION="5.4.1"
PKG_URL="https://fossies.org/linux/misc/zsh-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses pcre readline libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --bindir=/bin \
			      --enable-multibyte \
			      --enable-cap \
			      --disable-pcre \
			      --disable-ansi2knr \
			      --enable-dynamic \
			      --with-term-lib=ncurses \
			      --disable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --disable-gdbm"