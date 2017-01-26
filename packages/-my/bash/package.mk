PKG_NAME="bash"
PKG_VERSION="4.4"
PKG_URL="ftp://ftp.cwru.edu/pub/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-ltermcap -lcurses" 
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getcwd_malloc=yes \
			      bash_cv_job_control_missing=present \
			      bash_cv_sys_named_pipes=present \
			      bash_cv_func_sigsetjmp=present \
			      bash_cv_printf_a_format=yes \
			      --enable-static \
                           --disable-shared \
                           --bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --enable-static-link \
                           --disable-rpath \
                           --cache-file=/dev/null \
                           --enable-history \
                           --enable-alias \
                           --enable-job-control"  

post_makeinstall_target() {
  rm -rf $INSTALL/bin/bashbug
  ln -sf /bin/bash $INSTALL/bin/sh
}