PKG_NAME="gsmartcontrol"
PKG_VERSION="0.8.7"
PKG_ARCH="x86_64"
PKG_URL="https://sourceforge.net/projects/gsmartcontrol/files/0.8.7/gsmartcontrol-0.8.7.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"


pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
./configure
}

