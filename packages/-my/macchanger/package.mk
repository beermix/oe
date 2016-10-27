PKG_NAME="macchanger"
PKG_VERSION="f4f66e1"
PKG_URL="https://github.com/alobbs/macchanger/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			  --enable-static \
			  --disable-shared \
			  --datarootdir=/storage/.config/macchanger \
			  --with-gnu-ld"