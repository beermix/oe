PKG_NAME="git"
PKG_VERSION="2.12.2"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre zlib openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  #export NO_EXPAT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
  export NO_GETTEXT="YesPlease"
  export NO_UNIX_SOCKETS="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_PERL="YesPlease"
  export NO_PYTHON="YesPlease" 
  export NO_TCLTK="YesPlease"
  export NO_SVN_TESTS="YesPlease"
  export USE_LIBPCRE="1"
  export XDL_FAST_HASH="YesPlease"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --with-curl \
			      --with-libpcre \
			      --with-expat \
			      --with-zlib \
			      --with-tcltk=no \
			      --with-editor=nano \
			      --with-iconv"


