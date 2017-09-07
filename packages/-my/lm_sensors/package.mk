PKG_NAME="lm_sensors"
PKG_VERSION="8d510a7"
PKG_GIT_URL="https://github.com/groeck/lm-sensors"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="BUILD_STATIC_LIB=1 SBINDIR=/usr/bin CC=$CC AR=$AR"
PKG_MAKEINSTALL_OPTS_TARGET="BUILD_STATIC_LIB=1 BINDIR=/usr/bin SBINDIR=/usr/bin LIBDIR=/usr/lib CC=$CC AR=$AR"

pre_make_target() {
  export CFLAGS="$CFLAGS"
  export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/local
}