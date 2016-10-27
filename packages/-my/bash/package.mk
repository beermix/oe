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

MAKEFLAGS=-j1

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --bindir=/bin \
                           --enable-readline \
                           --without-bash-malloc \
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
			   --enable-coprocesses"
			   
			   
post_makeinstall_target() {
  rm -rf $INSTALL/bin/bashbug
}

