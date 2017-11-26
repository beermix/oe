PKG_NAME="rar"
PKG_VERSION="5.3.0"
PKG_URL="https://dl.dropboxusercontent.com/s/zwbt377xu8zisve/rar-5.3.0.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"



pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
}

