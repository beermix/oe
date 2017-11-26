PKG_NAME="libelf-compat"
PKG_VERSION="328643b"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_GIT_URL="https://github.com/sabotage-linux/libelf-compat"
PKG_DEPENDS_HOST="ccache:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"




make_host() {
  make prefix=$TOOLCHAIN install
}

makeinstall_host() {
  make prefix=$TOOLCHAIN install
}

make_target() {
  make CC=$CC prefix=$SYSROOT_PREFIX/usr install
}

makeinstall_target() {
  make CC=$CC prefix=$SYSROOT_PREFIX/usr install
}



