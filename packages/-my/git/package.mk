PKG_NAME="git"
PKG_VERSION="2.12.2"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre zlib openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  CC="$CC" \
  CFLAGS="$CFLAGS" \
  CPPFLAGS="$CPPFLAGS" \
  LDFLAGS="$LDFLAGS" \
  NO_EXPAT="YesPlease" \
  NO_MKSTEMPS="YesPlease" \
  NO_GETTEXT="YesPlease" \
  NO_UNIX_SOCKETS="YesPlease" \
  NO_ICONV="YesPlease" \
  NO_NSEC="YesPlease" \
  NO_PERL="YesPlease" \
  NO_PYTHON="YesPlease" \
  NO_TCLTK="YesPlease" \
  NO_INSTALL_HARDLINKS="yes" \
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --with-curl \
			      --with-libpcre \
			      --with-expat \
			      --with-zlib \
			      --with-tcltk=no \
			      --with-editor=nano \
			      --with-iconv"


