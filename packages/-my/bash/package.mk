PKG_NAME="bash"
PKG_VERSION="4.3.48"
PKG_URL="https://dl.dropboxusercontent.com/s/afsixaktnwv42b7/bash-4.3.48.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline dash"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo -ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_sys_named_pipes=present \
			      bash_cv_func_sigsetjmp=present \
			      bash_cv_getenv_redef=no \
                           --disable-shared \
                           --bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --disable-static-link \
                           --enable-casemod-expansions \
                           --enable-process-substitution \
                           --enable-coprocesses \
                           --enable-history \
                           --enable-cond-regexp \
                           --enable-alias \
                           --enable-select \
                           --enable-net-redirections \
                           --enable-dparen-arithmetic \
                           --enable-directory-stack \
                           --enable-direxpand-default \
                           --enable-cond-command \
                           --enable-command-timing \
                           --enable-bang-history \
                           --enable-array-variables \
                           --enable-glob-asciiranges-default \
                           --enable-restricted \
                           --enable-job-control"
			   
post_makeinstall_target() {
  ln -sfv bash $INSTALL/bin/rbash
  ln -sfv dash $INSTALL/bin/sh
}
