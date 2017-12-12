PKG_NAME="libudns"
PKG_VERSION="afca67f"
PKG_GIT_URL="https://github.com/shadowsocks/libudns"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}