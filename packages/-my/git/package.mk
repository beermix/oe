PKG_NAME="git"
PKG_VERSION="2.14.2"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre2 expat zlib openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
  export CC="$CC"
  export CFLAGS="$CFLAGS"
  export CXXFLAGS="$CXXFLAGS"
  export CPPFLAGS="$CPPFLAGS"
  export LDFLAGS="$LDFLAGS"
  
#  export NO_EXPAT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
#  export NO_GETTEXT="YesPlease"
  export NO_UNIX_SOCKETS="YesPlease"
  export NO_ICONV="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_PERL="YesPlease"
#  export NO_PYTHON="YesPlease"
  export NO_TCLTK="YesPlease"
  export NO_INSTALL_HARDLINKS="yes"
}

PKG_CONFIGURE_OPTS_TARGET="--with-curl=$SYSROOT_PREFIX/usr \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --with-editor=/usr/bin/nano \
			      --with-expat=$SYSROOT_PREFIX/usr \
			      --with-libpcre2=$SYSROOT_PREFIX/usr \
			      --disable-option-checking"


#make_target() {
#  make SHELL='sh -x'
#}