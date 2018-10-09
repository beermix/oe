PKG_NAME="nettle"
PKG_VERSION="3.4"
PKG_ARCH="any"
PKG_SITE="https://ftp.gnu.org/gnu/nettle/?C=M;O=D"
PKG_URL="https://ftp.gnu.org/gnu/nettle/nettle-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Nettle is a cryptographic library that is designed to fit easily in more or less any context: In crypto toolkits for object-oriented languages (C++, Python, Pike, ...), in applications like LSH or GNUPG, or even in kernel space."

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation \
			      --disable-openssl \
			      --disable-arm-neon \
			      --enable-mini-gmp"