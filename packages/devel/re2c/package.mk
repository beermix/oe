PKG_NAME="re2c"
PKG_VERSION="0.16"
PKG_VERSION="1.03"
PKG_URL="https://github.com/skvadrik/re2c/releases/download/$PKG_VERSION/re2c-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/skvadrik/re2c/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="bison:host"
PKG_SECTION="devel"
PKG_TOOLCHAIN="autotools"

post_unpack() {
  cp -r $PKG_BUILD/re2c/* $PKG_BUILD/
}

PKG_CONFIGURE_OPTS_HOST="--disable-docs"
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"