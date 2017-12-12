PKG_NAME="nettle"
PKG_VERSION="3.3"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.lysator.liu.se/~nisse/nettle/"
PKG_URL="https://ftp.gnu.org/gnu/nettle/nettle-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp openssl"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Nettle is a cryptographic library that is designed to fit easily in more or less any context: In crypto toolkits for object-oriented languages (C++, Python, Pike, ...), in applications like LSH or GNUPG, or even in kernel space."

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
}

PKG_CONFIGURE_OPTS_TARGET="CC_FOR_BUILD=$HOST_CC \
			    --disable-documentation \
			    --disable-shared \
			    --enable-static \
			    --disable-openssl"
