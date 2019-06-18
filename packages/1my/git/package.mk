PKG_NAME="git"
PKG_VERSION="2.22.0"
PKG_SHA256="159e4b599f8af4612e70b666600a3139541f8bacc18124daf2cbe8d1b934f29f"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre zlib openssl"
PKG_DEPENDS_HOST="zlib:host pcre:host"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME

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

#PKG_CONFIGURE_OPTS_TARGET="--without-iconv"