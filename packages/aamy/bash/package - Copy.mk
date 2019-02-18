PKG_NAME="bash"
PKG_VERSION="4.4.12"
PKG_SITE="http://ftp.gnu.org/gnu/bash/?C=M;O=D"
PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"


PKG_CONFIGURE_OPTS_TARGET="bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_sys_named_pipes=present \
			      bash_cv_func_sigsetjmp=present \
			      bash_cv_printf_a_format=yes \
			      bash_cv_getenv_redef=no \
			      --with-curses \
			      --enable-history \
			      --disable-rpath \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
                           --cache-file=/dev/null"

post_makeinstall_target() {
  ln -sfv bash $INSTALL/usr/bin/sh
}

