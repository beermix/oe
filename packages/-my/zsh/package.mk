PKG_NAME="zsh"
PKG_VERSION="364c404"
PKG_GIT_URL="https://github.com/zsh-users/zsh"
PKG_DEPENDS_TARGET="toolchain libcap pcre readline gdbm libcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
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
			   --enable-gdbm"

post_makeinstall_target() {
  rm $INSTALL/bin/zsh-5*
  rm -rf $INSTALL/usr/share/zsh/$PKG_VERSION/help
}

# --enable-readnullcmd=pager  --enable-zsh-secure-free