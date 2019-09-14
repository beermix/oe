PKG_NAME="bash"
PKG_VERSION="d894cfd"
PKG_SHA256=""
#PKG_SITE="https://github.com/bminor/bash/"
#PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_BUILD_FLAGS="-parallel"

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
			      --enable-direxpand-default \
			      --enable-job-control \
			      --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}