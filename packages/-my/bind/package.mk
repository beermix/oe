PKG_NAME="bind"
PKG_VERSION="9.11.0"
PKG_URL="ftp://ftp.isc.org/isc/bind9/9.11.0/bind-$PKG_VERSION.tar.gz"
#PKG_URL="http://cl.ly/0h2B0T2e0D0c/download/bind9.tar.xz"
#PKG_SOURCE_DIR="bind9"
PKG_DEPENDS_TARGET="toolchain sqlite libcap json-c openssl readline"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="BUILD_CC="$CC" \
                           --prefix=/usr \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld \
                           --enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --with-randomdev=/dev/urandom \
                           --prefix=/usr \
                           --with-ecdsa=no \
                           --with-libxml2 \
                           --with-readline \
                           --with-gssapi=no \
                           --with-gost=no \
                           --with-libjson=no \
                           --enable-seccomp=no"


