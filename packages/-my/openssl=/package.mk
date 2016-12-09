PKG_NAME="openssl"
PKG_VERSION="1.0.2h"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.openssl.org/"
PKG_URL="http://www.openssl.org/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib"

PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export MAKEFLAGS=-j1

  case $TARGET_ARCH in
    i386)
      openssl_TARGET=linux-elf
      ;;
    x86_64)
      openssl_TARGET=linux-x86_64
      ;;
    arm)
      openssl_TARGET=linux-armv4
      ;;
    powerpc)
      openssl_TARGET=linux-ppc
      ;;
    powerpc64)
      openssl_TARGET=linux-ppc64
      ;;
  esac
}

configure_target() {
  ./Configure --prefix=/usr \
              --libdir=lib \
              --openssldir="$SSL_CERTIFICATES" \
              shared \
              threads \
              zlib-dynamic \
              enable-camellia \
              enable-mdc2 \
              enable-tlsext \
              no-rc5 \
              $openssl_TARGET
}

make_target() {
  make CC="$CC" \
       AR="$AR r" \
       RANLIB="$RANLIB" \
       MAKEDEPPROG="$CC" \
       depend all build-shared

}

makeinstall_target() {
  make INSTALL_PREFIX=$SYSROOT_PREFIX install
  make INSTALL_PREFIX=$INSTALL install
  chmod 755 $INSTALL/usr/lib/*.so*
  chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/pki/tls/misc
  rm -rf $INSTALL/usr/bin/c_rehash
  rm -rf $INSTALL/usr/ssl/man
  $STRIP $INSTALL/usr/bin/openssl

# ca-certification: provides a tool to download and create ca-bundle.crt
# download url: http://curl.haxx.se
# create new cert: perl ./mk-ca-bundle.pl
  mkdir -p $INSTALL/$SSL_CERTIFICATES
    cp $PKG_DIR/cert/ca-bundle.crt $INSTALL/$SSL_CERTIFICATES/cacert.pem
}
