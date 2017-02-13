PKG_NAME="acl"
PKG_VERSION="38f32ea"
PKG_GIT_URL="git://git.sv.gnu.org/acl.git"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_DEPENDS_HOST="toolchain attr:host"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"