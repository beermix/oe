PKG_NAME="bash"
PKG_VERSION="bc00779"
PKG_GIT_URL="https://github.com/bminor/bash"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="$LIBS -ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --enable-static-link \
                           --enable-command-timing \
                           --enable-bang-history \
                           --enable-coprocesses \
                           --enable-direxpand-default \
                           --enable-multibyte \
                           --enable-progcomp \
                           --enable-history \
                           --enable-alias \
                           --disable-rpath"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv bash $INSTALL/bin/rbash
  ln -sfv bash $INSTALL/bin/sh
}
