PKG_NAME="bash"
PKG_VERSION="4.3.48"
PKG_URL="https://dl.dropboxusercontent.com/s/afsixaktnwv42b7/bash-4.3.48.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo -ltermcap"
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --enable-static-link"
			   
post_makeinstall_target() {
  mkdir -p $INSTALL/bin
  ln -sfv bash $INSTALL/bin/rbash
}
