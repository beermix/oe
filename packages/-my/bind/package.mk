PKG_NAME="bind"
PKG_VERSION="9.11.1"
PKG_URL="http://www.mirrorservice.org/sites/ftp.isc.org/isc/bind9/9.11.1/bind-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain sqlite libcap openssl libidn2"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_taret() {
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  export LIBS="-lterminfo -lreadline"
  export LDFLAGS="$LDFLAGS -lz -lpthread -lm -ldl"
}

PKG_CONFIGURE_OPTS_TARGET="BUILD_CC="$HOST_CC" \
                           --enable-threads \
                           --disable-shared \
                           --disable-ipv6 \
                           --enable-atomic \
                           --with-gnu-ld \
                           --with-linidn2=$SYSROOT_PREFIX/usr \
                           --with-libiconv=$SYSROOT_PREFIX/usr \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --with-zlib=no \
                           --sysconfdir=/storage/.config \
                           --with-randomdev=/dev/urandom \
                           --with-ecdsa=yes \
                           --with-libxml2=$SYSROOT_PREFIX/usr \
                           --with-readline=no \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gssapi=no \
                           --with-gost=no \
                           --with-libjson=no \
                           --enable-seccomp=no"


