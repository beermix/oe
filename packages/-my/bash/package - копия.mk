PKG_NAME="bash"
PKG_VERSION="4.3.48"
PKG_URL="https://dl.dropboxusercontent.com/s/afsixaktnwv42b7/bash-4.3.48.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"

pre_configure_target() {
  export LIBS="-lterminfo -ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getenv_redef=no \
			      bash_cv_job_control_missing=yes \
			      --enable-static \
                           --disable-shared \
                           --bindir=/bin \
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
  ln -sfv bash $INSTALL/bin/rbash
  #ln -sfv bash $INSTALL/bin/sh
}
