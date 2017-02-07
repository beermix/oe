PKG_NAME="lnav"
PKG_VERSION="c606e11"
PKG_GIT_URL="https://github.com/tstack/lnav"
PKG_DEPENDS_HOST="toolchain sqlite"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo"
  export CURSES_LIB="-lterminfo"
  export CC_FOR_BUILD="$HOST_CC"
  export CPPFLAGS_FOR_BUILD="$HOST_CPPFLAGS"
  export CFLAGS_FOR_BUILD="$HOST_CFLAGS"
  export LDFLAGS_FOR_BUILD="$HOST_LDFLAGS"
  unset PKG_CONFIG_ALLOW_SYSTEM_CFLAGS
  cd $ROOT/$PKG_BUILD
  autoreconf --verbose --install --force -I m4
}

PKG_CONFIGURE_OPTS_TARGET="--disable-dependency-tracking --enable-silent-rules --with-pcre"
