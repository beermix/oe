PKG_NAME="bash"
PKG_VERSION="4.4.12"
PKG_SITE="http://ftp.gnu.org/gnu/bash/?C=M;O=D"
PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
			      --enable-history \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
                           --cache-file=/dev/null \
                           --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}

