PKG_NAME="lm_sensors"
PKG_VERSION="83cafd2"
PKG_URL="https://github.com/groeck/lm-sensors/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="lm-sensors-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_AUTORECONF="no"

# TODO: PKG_MAKE_OPTS_TARGET + ETCDIR=/storage/.kodi/addons/tools.lm_sensors/data if one wants sensor3.co$
PKG_MAKE_OPTS_TARGET="PREFIX=/usr CC=$CC AR=$AR"
PKG_MAKEINSTALL_OPTS_TARGET="PREFIX=/usr"

pre_make_target() {
  export CFLAGS="$TARGET_CFLAGS"
  export CPPFLAGS="$TARGET_CPPFLAGS -D_DEFAULT_SOURCE"
}
