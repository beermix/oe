PKG_NAME="zsh"
PKG_VERSION="5.3.1"
PKG_URL="https://fossies.org/linux/misc/zsh-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses pcre readline"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-multibyte \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --enable-dynamic \
			      --sysconfdir=/storage/.config \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --disable-gdbm \
			      --enable-zsh-secure-free \
			      --with-term-lib=ncursesw \
			      --disable-dynamic-nss \
			      --disable-zsh-debug \
			      --disable-cap \
			      --enable-unicode9"