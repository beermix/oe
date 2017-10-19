PKG_NAME="zsh"
PKG_VERSION="5.4.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline libcap"
PKG_SECTION="my"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="$LIBS -lncursesw -ltinfo"
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=2||g"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-multibyte \
			      --enable-function-subdirs \
			      --with-tcsetpgrp \
			      --with-term-lib=ncursesw \
			      --enable-pcre \
			      --enable-cap \
			      --enable-zsh-secure-free"