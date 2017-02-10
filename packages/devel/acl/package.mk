PKG_NAME="acl"
PKG_VERSION="ea3c6bb711e76d91759f8bf5475e1900362a3142"
PKG_GIT_URL="git://git.sv.gnu.org/acl.git"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_DEPENDS_HOST="toolchain attr:host"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"