PKG_NAME="bash"
PKG_VERSION="4.4.12"
PKG_SITE="http://ftp.gnu.org/gnu/bash/?C=M;O=D"
PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
                           --cache-file=/dev/null"

post_makeinstall_target() {
 # mkdir -p $INSTALL/bin
  #ln -sfv bash $INSTALL/bin/rbash
  ln -sfv bash $INSTALL/usr/bin/sh
}