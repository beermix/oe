PKG_NAME="git"
PKG_VERSION="2.23.0"
PKG_SHA256="234fa05b6839e92dc300b2dd78c92ec9c0c8d439f65e1d430a7034f60af16067"
PKG_URL="https://www.kernel.org/pub/software/scm/git/git-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain curl pcre zlib openssl"
PKG_DEPENDS_HOST="zlib:host pcre:host"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+size"

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME

  export CC="$CC"
  export CFLAGS="$CFLAGS"
  export CPPFLAGS="$CPPFLAGS"
  export LDFLAGS="$LDFLAGS"
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

PKG_CONFIGURE_OPTS_TARGET="--without-iconv"