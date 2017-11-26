PKG_NAME="bash"
PKG_VERSION="4.4"
PKG_URL="ftp://ftp.cwru.edu/pub/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"



pre_configure_target() {
  export LIBS="-ltermcap -lcurses"
  export MAKEFLAGS="-j1"
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getenv_redef=no \
			      bash_cv_job_control_missing=yes \
                           --bindir=/bin \
                           --enable-static \
                           --disable-shared \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --disable-static-link \
                           --cache-file=/dev/null \
                           --enable-history \
                           --enable-alias \
                           --enable-job-control"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv bash $INSTALL/bin/rbash
  #ln -sfv bash $INSTALL/bin/sh
}
