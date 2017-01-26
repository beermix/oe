PKG_NAME="bash"
PKG_VERSION="4.3.48"
PKG_URL="https://dl.dropboxusercontent.com/s/afsixaktnwv42b7/bash-4.3.48.tar.gz"
#PKG_URL="ftp://ftp.cwru.edu/pub/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses readline"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo -ltermcap"
}

PKG_CONFIGURE_OPTS_TARGET="bash_cv_getenv_redef=no \
                           --enable-static \
                           --disable-shared \
                           --bindir=/bin \
                           --with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --enable-static-link \
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
  ln -sf bash $INSTALL/bin/rbash
  ln -sf bash $INSTALL/bin/sh
}			   

