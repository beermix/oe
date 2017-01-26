PKG_NAME="bash"
PKG_VERSION="4.4"
PKG_URL="ftp://ftp.cwru.edu/pub/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-ltermcap -lcurses"
  CONCURRENCY_MAKE_LEVEL=1
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_sys_named_pipes=present \
			      bash_cv_func_sigsetjmp=present \
                           --enable-static \
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
                           --enable-restricted \
                           --enable-largefile \
                           --enable-job-control"

post_makeinstall_target() {
  rm -rf $INSTALL/bin/bashbug
  ln -s /bin/bash $INSTALL/bin/sh
 }