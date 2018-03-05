PKG_NAME="net-tools"
PKG_VERSION="x3"
PKG_URL="http://192.168.1.200:8080/%2Fnet-tools-x3.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline openssl"
PKG_SECTION="network"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  cd $PKG_BUILD
  yes "" | ./configure.sh config.in
}

make_target() {
  make CC="$CC" CXX="$CXX" RANLIB="$RANLIB" AR="$AR" STRIP="$STRIP" -j1
}

