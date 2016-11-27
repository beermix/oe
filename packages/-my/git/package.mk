PKG_NAME="git"
PKG_VERSION="2.10.2"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre expat libz libssh2 libiconv"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  #export NO_EXPAT="YesPlease"
  export NO_MKSTEMPS="YesPlease"
  #export NO_GETTEXT="YesPlease"
  #export NO_UNIX_SOCKETS="YesPlease"
  export NO_NSEC="YesPlease"
  export NO_PERL="YesPlease"
  export NO_PYTHON="YesPlease" 
  export NO_TCLTK="YesPlease"
  export NO_SVN_TESTS="YesPlease"
  export USE_LIBPCRE="1"
  #export XDL_FAST_HASH="YesPlease"
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
				   --with-curl \
				   --with-gnutls \
				   --with-libpcre \
				   --with-expat \
				   --enable-pthreads=-lpthread \
				   --with-zlib=$ROOT/$TOOLCHAIN \
				   --with-tcltk=no \
				   --with-editor=nano \
				   --with-iconv"


