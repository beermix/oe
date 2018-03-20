PKG_NAME="bash"
PKG_VERSION="4.4.18"
PKG_SITE="http://ftp.gnu.org/gnu/bash/?C=M;O=D"
PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_BUILD_FLAGS="-parallel"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
			      --enable-cond-command \
			      --enable-history \
			      --enable-job-control \
			      --enable-readline \
			      --enable-extended-glob \
			      --enable-progcomp \
			      --enable-arith-for-command \
			      --enable-directory-stack \
			      --with-bash-malloc=no"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}

