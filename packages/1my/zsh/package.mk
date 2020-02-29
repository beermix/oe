PKG_NAME="zsh"
PKG_VERSION="5.8"
PKG_SHA256="dcc4b54cc5565670a65581760261c163d720991f0d06486da61f8d839b52de27"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://sourceforge.net/projects/zsh/files/zsh/$PKG_VERSION/zsh-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline libcap"

pre_configure_target() {
  export LIBS="-lncursesw -ltinfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-cap \
			      --enable-pcre \
			      --disable-ansi2knr \
			      --disable-zsh-debug \
			      --with-term-lib='ncursesw' \
			      --enable-multibyte \
			      --enable-function-subdirs \
			      --enable-fndir=/usr/lib/zsh/functions \
			      --enable-scriptdir=/usr/lib/zsh/scripts \
			      --with-tcsetpgrp \
			      --enable-zsh-secure-free"
