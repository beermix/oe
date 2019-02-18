PKG_NAME="libuser"
PKG_VERSION="0.62"
PKG_URL="https://copy.com/GLr9VInlymb3/libuser-0.62.tar.xz"
PKG_DEPENDS_TARGET="toolchain Python sqlite ncurses"

PKG_SECTION="my"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
  autoreconf -i
}

TARGET_CONFIGURE_OPTS="--prefix=/"
