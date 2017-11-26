PKG_NAME="lm_sensors"
PKG_VERSION="83cafd2"
PKG_URL="https://github.com/groeck/lm-sensors/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="lm-sensors-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"


PKG_MAKE_OPTS_TARGET="BUILD_STATIC_LIB=1 SBINDIR=/usr/bin CC=$CC AR=$AR"
PKG_MAKEINSTALL_OPTS_TARGET="BUILD_STATIC_LIB=1 BINDIR=/usr/bin SBINDIR=/usr/bin LIBDIR=/usr/lib CC=$CC AR=$AR"

pre_make_target() {
  export CFLAGS="$CFLAGS"
  export CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/local
}