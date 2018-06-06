PKG_NAME="bash"
PKG_VERSION="6444760"
PKG_SITE="http://ftp.gnu.org/gnu/bash/?C=M;O=D"
PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
			      --enable-cond-command \
			      --enable-history \
			      --enable-job-control \
			      --enable-readline \
			      --with-installed-readline \
			      --enable-extended-glob \
			      --without-bash-malloc"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}

