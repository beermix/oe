PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-ltermcap -lcurses"
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --disable-net-redirections \
                           --enable-command-timing \
                           --enable-job-control \
                           --enable-history \
                           --disable-nls \
                           --disable-rpath"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv bash $INSTALL/bin/rbash
  #ln -sfv bash $INSTALL/bin/sh
}
