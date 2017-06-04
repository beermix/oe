PKG_NAME="libglvnd"
PKG_VERSION="6bcecd8"
PKG_GIT_URL="https://github.com/NVIDIA/libglvnd"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-sysroot=$SYSROOT_PREFIX"