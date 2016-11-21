PKG_NAME="bash"
PKG_VERSION="4.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/bash/bash.html"
PKG_URL="ftp://ftp.gnu.org/gnu/bash/bash-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --bindir=/bin \
                           --without-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline \
                           --enable-static-link"
			   
			   
post_makeinstall_target() {
  rm -rf $INSTALL/bin/bashbug
}

