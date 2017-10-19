PKG_NAME="zsh"
PKG_VERSION="dc1f3aa"
PKG_GIT_URL="https://github.com/zsh-users/zsh"
PKG_DEPENDS_TARGET="toolchain ncurses libcap pcre readline gdbm libpcap"
PKG_SECTION="my"

PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --bindir=/bin \
			      --enable-multibyte \
			      --disable-silent-rules \
			      --enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-dynamic \
			      --sysconfdir=/storage/.config \
			      --with-term-lib=ncursesw \
			      --disable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-gdbm \
			      --enable-zsh-secure-free \
			      --enable-readnullcmd=pager"

post_makeinstall_target() {
  rm $INSTALL/bin/zsh-5*
  rm -rf $INSTALL/usr/share/zsh/$PKG_VERSION/help
}