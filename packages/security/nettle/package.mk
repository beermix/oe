PKG_NAME="nettle"
PKG_VERSION="3.4.1"
PKG_SHA256="f941cf1535cd5d1819be5ccae5babef01f6db611f9b5a777bae9c7604b8a92ad"
PKG_SITE="https://ftp.gnu.org/gnu/nettle/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/nettle/nettle-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation \
			      --disable-openssl \
			      --disable-arm-neon \
			      --enable-mini-gmp"