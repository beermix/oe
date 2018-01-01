PKG_NAME="libseccomp"
PKG_VERSION="2.3.2"
PKG_URL="https://github.com/seccomp/libseccomp/releases/download/v2.3.2/libseccomp-2.3.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
