PKG_NAME="zsh"
PKG_VERSION="5.4.1"
PKG_GIT_URL="https://github.com/zsh-users/zsh"
PKG_DEPENDS_TARGET="toolchain netbsd-curses pcre readline libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --bindir=/bin \
			      --enable-multibyte \
			      --disable-silent-rules \
			      --enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-dynamic \
			      --sysconfdir=/storage/.config \
			      --disable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-gdbm \
			      --enable-zsh-secure-free \
			      --enable-readnullcmd=pager"