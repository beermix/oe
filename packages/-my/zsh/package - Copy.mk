PKG_NAME="zsh"
PKG_VERSION="5.1.1"
#PKG_URL="https://github.com/zsh-users/zsh/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://sourceforge.net/projects/zsh/files/zsh/${PKG_VERSION}/zsh-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libcap pcre gawk readline gdbm libsigc++ jansson which valgrind"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
   strip_lto
   export LIBS=-lterminfo
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --bindir=/bin \
			   --enable-multibyte \
			   --with-tcsetpgrp \
			   --disable-etcdir \
			   --enable-cap \
			   --enable-pcre \
			   --disable-nls \
			   --disable-shared \
			   --enable-static \
			   --with-term-lib=ncursesw \
			   --enable-gdbm"

post_makeinstall_target() {
  rm -f $INSTALL/bin/zsh-${PKG_VERSION}
  rm -rf $INSTALL/usr/share/zsh/${PKG_VERSION}/help
}
