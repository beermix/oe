PKG_NAME="zsh"
PKG_VERSION="5.3"
PKG_URL="https://sourceforge.net/projects/zsh/files/zsh/5.3/zsh-5.3.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libcap pcre readline gdbm libpcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
			      --enable-multibyte \
			      --disable-silent-rules \
			      --enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-dynamic \
			      --sysconfdir=/storage/.config \
			      --with-term-lib=ncursesw \
			      --enable-etcdir \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --enable-gdbm \
			      --enable-zsh-secure-free \
			      --enable-readnullcmd=pager \
			      --enable-max-jobtable-size=256 \
			      --with-term-lib=tinfo \
			      --disable-dynamic-nss \
			      --disable-zsh-debug"

post_makeinstall_target() {
  rm $INSTALL/bin/zsh-5*
  rm -rf $INSTALL/usr/share/zsh/$PKG_VERSION/help
}
