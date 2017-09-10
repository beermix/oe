PKG_NAME="acl"
PKG_VERSION="fa5f683"
PKG_GIT_URL="git://git.sv.gnu.org/acl.git"
PKG_DEPENDS_TARGET="toolchain attr"
PKG_DEPENDS_HOST="toolchain attr:host"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-gettext=no --disable-shared --with-pic LDFLAGS=-lattr"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}
