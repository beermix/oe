PKG_NAME="net-tools"
PKG_VERSION="1.60-git"
PKG_URL="https://dl.dropboxusercontent.com/s/itcgguojj6sw2an/net-tools-1.60-git.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline openssl"
PKG_SECTION="my"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $PKG_BUILD
  yes "" | ./configure.sh config.in
}

make_target() {
  make CC="$CC" CXX="$CXX" RANLIB="$RANLIB" AR="$AR" STRIP="$STRIP" -j1
}