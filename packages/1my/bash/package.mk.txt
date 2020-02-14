PKG_NAME="bash"
PKG_VERSION="9f597fd"
PKG_SHA256="acd35b78d07c1824b017574ed8c9fabec6d42010f531e82b0edfff69f4f25d76"
#PKG_SITE="https://github.com/bminor/bash/"
#PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_BUILD_FLAGS="-parallel"

PKG_CONFIGURE_OPTS_TARGET="bash_cv_func_sigsetjmp=present \
			      bash_cv_printf_a_format=yes \
			      bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_dev_fd=whacky \
			      bash_cv_sys_named_pipes=present \
			      --with-curses \
			      --enable-readline \
			      --without-bash-malloc \
			      --with-installed-readline \
			      --enable-direxpand-default \
			      --enable-job-control \
			      --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}