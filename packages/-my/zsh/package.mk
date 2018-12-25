PKG_NAME="zsh"
PKG_VERSION="5.6.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="https://sourceforge.net/projects/zsh/files/zsh/$PKG_VERSION/zsh-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline libcap"

pre_configure_target() {
  export LIBS="$LIBS -lncursesw -ltinfo"
  export CFLAGS="$CFLAGS -fstack-protector-strong"
  export CXXFLAGS="$CXXFLAGS -fstack-protector-strong"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-multibyte \
			      --enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-dynamic \
			      --sysconfdir=/storage/.config \
			      --with-term-lib=ncursesw \
			      --enable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-zsh-secure-free \
			      --enable-readnullcmd=pager \
			      --disable-zsh-debug"
