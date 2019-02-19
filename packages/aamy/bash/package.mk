PKG_NAME="bash"
PKG_VERSION="ddf3f64"
#PKG_SITE="https://github.com/bminor/bash/"
#PKG_URL="http://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/bminor/bash/archive/${PKG_VERSION}.tar.gz"
#PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_BUILD_FLAGS="+hardening"

PKG_CONFIGURE_OPTS_TARGET="--enable-readline \
			      --with-installed-readline \
			      --with-bash-malloc=no \
			      --disable-rpath"

#post_makeinstall_target() {
#  ln -sfv bash $INSTALL/usr/bin/sh
#}