PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#CONCURRENCY_MAKE_LEVEL=1 --enable-static-link --enable-profiling

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin
			      --with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
			      --disable-static-link \
                           --disable-rpath \
                           --cache-file=/dev/null \
                           --enable-history \
                           --enable-alias \
                           --enable-job-control"

post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  #ln -sf bash $INSTALL/bin/sh
}
