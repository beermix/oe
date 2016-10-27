PKG_NAME="lm_sensors"
PKG_VERSION="3.4.0"
PKG_URL="http://sources.libreelec.tv/mirror/lm_sensors/lm_sensors-3.4.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_MAKE_OPTS_TARGET="PREFIX=/usr CC=$CC AR=$AR"
PKG_MAKEINSTALL_OPTS_TARGET="PREFIX=/usr"

pre_make_target() {
  export CFLAGS="$CFLAGS"
  export CPPFLAGS="$CPPFLAGS"
}