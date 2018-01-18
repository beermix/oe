PKG_NAME="git"
PKG_VERSION="2.16.0"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre expat zlib openssl"
PKG_SECTION="devel"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
 
#  export NO_EXPAT="YesPlease"
  export NO_ICONV="YesPlease"
  export NO_PYTHON="YesPlease"
  export NO_UNIX_SOCKETS="YesPlease"
  export NO_GETTEXT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
  export NO_PERL="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_TCLTK="YesPlease"
  export NO_INSTALL_HARDLINKS="yes"
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_fread_reads_directories=yes ac_cv_snprintf_returns_bogus=yes --with-editor=/usr/bin/nano"

#make_target() {
#  make SHELL='sh -x'
#}