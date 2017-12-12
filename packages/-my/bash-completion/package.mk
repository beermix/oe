PKG_NAME="bdwgc"
PKG_VERSION="d8bfa89"
PKG_GIT_URL="https://github.com/scop/bash-completion"
PKG_DEPENDS_TARGET="toolchain libatomic_ops"

PKG_SECTION="devel"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --disable-debug"