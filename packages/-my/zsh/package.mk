PKG_NAME="zsh"
PKG_VERSION="5.6"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://sourceforge.net/projects/zsh/files/zsh/$PKG_VERSION/zsh-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline libcap"
PKG_SECTION="my"

pre_configure_target() {
  export LIBS="$LIBS -lncursesw -ltinfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-multibyte \
			      --enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-dynamic \
			      --enable-multibyte \
			      --sysconfdir=/storage/.config \
			      --with-term-lib=ncursesw \
			      --enable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-zsh-secure-free \
			      --enable-readnullcmd=pager \
			      --disable-zsh-debug"
