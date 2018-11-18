PKG_NAME="nasm"
PKG_VERSION="2.14"
PKG_SHA256="97c615dbf02ef80e4e2b6c385f7e28368d51efc214daa98e600ca4572500eec0"
PKG_LICENSE="BSD"
PKG_SITE="http://www.tortall.net/projects/yasm/"
PKG_URL="http://www.nasm.us/pub/nasm/releasebuilds/$PKG_VERSION/nasm-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"

PKG_CONFIGURE_OPTS_HOST="--disable-lto --disable-werror --disable-gdb"