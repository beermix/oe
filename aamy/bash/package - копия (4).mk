PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain ncurses readline"



#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin
			      --with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
			      --disable-static-link \
			      --enable-multibyte \
			      --enable-profiling \ \
			      --enable-job-control \
			      --enable-history \
			      --enable-coprocesses \
			      --enable-alias \
			      --enable-net-redirections \
			      --disable-minimal-config"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sf bash $INSTALL/bin/sh
}
