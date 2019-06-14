PKG_NAME="git"
PKG_VERSION="2.22.0"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre expat zlib openssl"
PKG_DEPENDS_HOST="zlib:host pcre:host expat:host"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  cd $PKG_BUILD
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  #export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`

  #export NO_EXPAT="YesPlease"
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

configure_target() {
  ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --prefix=/usr \
              --libexecdir=/usr/lib \
              ac_cv_snprintf_returns_bogus=no \
              ac_cv_fread_reads_directories=no \
              --with-gitconfig=/etc/gitconfig
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/lib/x86_64-linux-gnu
  rm -rf $INSTALL/usr/share/perl
}