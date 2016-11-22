PKG_NAME="bind"
PKG_VERSION="master"
PKG_GIT_URL="https://source.isc.org/git/bind9.git"
PKG_DEPENDS_TARGET="toolchain sqlite libcap json-c openssl readline"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="BUILD_CC="$CC" \
                           --prefix=/usr \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --with-gnu-ld \
                           --enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --with-randomdev=/dev/urandom \
                           --prefix=/usr \
                           --with-ecdsa=yes \
                           --with-libxml2 \
                           --with-readline \
                           --with-gssapi=no \
                           --with-gost=no \
                           --with-libjson=no \
                           --enable-seccomp=no"


