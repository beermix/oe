PKG_NAME="libseccomp"
PKG_VERSION="v2.3.1"
PKG_GIT_URL="https://github.com/seccomp/libseccomp"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"