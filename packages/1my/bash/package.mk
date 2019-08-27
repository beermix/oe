PKG_NAME="bash"
PKG_VERSION="9f597fd"
PKG_SHA256="acd35b78d07c1824b017574ed8c9fabec6d42010f531e82b0edfff69f4f25d76"
#PKG_SITE="https://github.com/bminor/bash/"
#PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"

PKG_CONFIGURE_OPTS_TARGET="--enable-readline \
			      --with-installed-readline \
			      --with-bash-malloc=no \
			      --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}