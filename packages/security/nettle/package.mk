# Made by github.com/escalade
PKG_NAME="nettle"
PKG_VERSION="3.3"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.lysator.liu.se/~nisse/nettle/"
PKG_URL="https://ftp.gnu.org/gnu/nettle/nettle-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp openssl"
PKG_SECTION="escalade/depends"
PKG_SHORTDESC="Nettle is a cryptographic library that is designed to fit easily in more or less any context: In crypto toolkits for object-oriented languages (C++, Python, Pike, ...), in applications like LSH or GNUPG, or even in kernel space."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation"

if [ "$PROJECT" = "$RPi2" ]; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-arm-neon"
fi

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

