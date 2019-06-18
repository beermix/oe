PKG_NAME="git"
PKG_VERSION="2.19.2"
PKG_SHA256="fce9a3a3297db5f3756c4553a2fc1fec209ee08178f8491e76ff4ff8fe7b8be9"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre zlib openssl"
PKG_DEPENDS_HOST="zlib:host pcre:host"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  #export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`

  #export CC="$TARGET_CC"
  #export CFLAGS="$TARGET_CFLAGS"
  #export CPPFLAGS="$TARGET_CPPFLAGS"
  #export LDFLAGS="$TARGET_LDFLAGS"
  export NO_EXPAT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
  export NO_GETTEXT="YesPlease"
  export NO_UNIX_SOCKETS="YesPlease"
  export NO_ICONV="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_PERL="YesPlease"
  export NO_PYTHON="YesPlease"
  export NO_TCLTK="YesPlease"
  export NO_INSTALL_HARDLINKS="yes"
}

#PKG_CONFIGURE_OPTS_TARGET="ac_cv_snprintf_returns_bogus=no ac_cv_fread_reads_directories=no --with-curl=no"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/x86_64-linux-gnu
  rm -rf $INSTALL/usr/share/perl
}