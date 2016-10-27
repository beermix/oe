PKG_NAME="sshfs"
PKG_VERSION="e5acfce"
PKG_SITE="https://github.com/libfuse/sshfs"
PKG_GIT_URL="https://github.com/libfuse/sshfs"
PKG_DEPENDS_TARGET="toolchain fuse netbsd-curses glib"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
}