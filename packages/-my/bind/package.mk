PKG_NAME="bind"
PKG_VERSION="9.11.0-P1"
PKG_GIT_URL="ftp://ftp.isc.org/isc/bind9/$PKG_VERSION/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap json-c openssl readline"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="BUILD_CC="$HOST_CC" \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld \
                           --enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --with-randomdev=/dev/urandom \
                           --with-ecdsa=yes \
                           --with-libxml2 \
                           --with-readline \
                           --with-gssapi=no \
                           --with-gost=no \
                           --with-libjson=no \
                           --enable-seccomp=no"


