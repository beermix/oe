PKG_NAME="lm_sensors"
PKG_VERSION="c755805"
PKG_SITE="https://github.com/groeck/lm-sensors"
PKG_URL="https://github.com/groeck/lm-sensors/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="lm-sensors-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"

# TODO: PKG_MAKE_OPTS_TARGET + ETCDIR=/storage/.kodi/addons/tools.lm_sensors/data if one wants sensor3.co$
PKG_MAKE_OPTS_TARGET="BUILD_STATIC_LIB=1 BUILD_SHARED_LIB=0 PREFIX=/usr CC=$CC AR=$AR"
PKG_MAKEINSTALL_OPTS_TARGET="BUILD_STATIC_LIB=1 BUILD_SHARED_LIB=0 PREFIX=/usr"

pre_make_target() {
  export CFLAGS="$TARGET_CFLAGS"
  export CPPFLAGS="$TARGET_CPPFLAGS -D_DEFAULT_SOURCE"
}
