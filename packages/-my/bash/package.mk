PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_sys_named_pipes=present \
			      bash_cv_func_sigsetjmp=present \
			      bash_cv_printf_a_format=yes \
			      --bindir=/bin \
                           --with-installed-readline \
                           --without-bash-malloc"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv bash $INSTALL/bin/rbash
  #ln -sfv bash $INSTALL/bin/sh
}
