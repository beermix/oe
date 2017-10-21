PKG_NAME="zsh"
PKG_VERSION="5.4.2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses pcre readline libcap"
PKG_SECTION="my"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="$LIBS -lncursesw -ltinfo"
#  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=2||g"`
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
			      --enable-max-jobtable-size=256 \
			      --disable-dynamic-nss \
			      --disable-zsh-debug"