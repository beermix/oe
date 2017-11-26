sPKG_NAME="xfstests"
PKG_VERSION="1"
PKG_URL="https://dl.dropboxusercontent.com/s/x48k5dl3dq0j19h/xfstests-1.tar.xz"
PKG_DEPENDS_TARGET="toolchain" 
PKG_DEPENDS_INIT="toolchain"


make_target() {
  make default
}
