sPKG_NAME="xfs-cmds"
PKG_VERSION="1"
PKG_URL="https://dl.dropboxusercontent.com/s/x1fb1us9z5v1vl3/xfs-cmds-1.tar.xz"
PKG_DEPENDS_TARGET="toolchain" 
PKG_DEPENDS_INIT="toolchain"


make_target() {
make default
}
