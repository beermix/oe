PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-ltermcap -lcurses"
  export MAKEFLAGS="-j1"
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getenv_redef=no \
			      bash_cv_job_control_missing=yes \
                           --bindir=/bin \
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
  ln -sfv bash $INSTALL/bin/sh
}
