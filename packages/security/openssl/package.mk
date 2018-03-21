PKG_NAME="openssl"
PKG_VERSION="1.0.2n"
PKG_SHA256="370babb75f278c39e0c50e8c4e7493bc0f18db6867478341a832a982fd15a8fe"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://www.openssl.org"
PKG_URL="https://www.openssl.org/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain yasm:host pcre zlib"
PKG_SECTION="security"
PKG_SHORTDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
#PKG_BUILD_FLAGS="-parallel"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_SHARED="--openssldir=/etc/ssl \
                           --libdir=lib \
                           shared \
                           threads \
                           enable-tlsext \
                           enable-unit-test \
                           no-ssl \
                           zlib-dynamic \
                           enable-camellia \
                           enable-mdc2 \
                           enable-ec_nistp_64_gcc_128"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./Configure --prefix=/ $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 "-Wa,--noexecstack $CFLAGS $LDFLAGS"
}

makeinstall_host() {
  make INSTALL_PREFIX=$TOOLCHAIN install_sw -j1
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 "-Wa,--noexecstack $CFLAGS $CPPFLAGS $LDFLAGS"
}

makeinstall_target() {
  make INSTALL_PREFIX=$INSTALL install_sw -j1
  make INSTALL_PREFIX=$SYSROOT_PREFIX install_sw -j1
  chmod 755 $INSTALL/usr/lib/*.so*
  chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/ssl/misc
  rm -rf $INSTALL/usr/bin/c_rehash

  debug_strip $INSTALL/usr/bin/openssl

  # create new cert: ./mkcerts.sh
  # cert from https://curl.haxx.se/docs/caextract.html
  mkdir -p $INSTALL/etc/ssl
  # perl $PKG_DIR/cert/mk-ca-bundle.pl
  # cp $PKG_BUILD/.$TARGET_NAME/ca-bundle.crt $INSTALL/etc/ssl/cert.pem
  cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cert.pem

  # backwards comatibility
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt
  mkdir -p $INSTALL/usr/lib/ssl
    ln -sf /etc/ssl/cert.pem $INSTALL/usr/lib/ssl/cert.pem
  # mkdir -p $INSTALL/etc/ssl/certs
  # ln -sf /etc/ssl/cert.pem $INSTALL/etc/ssl/certs/ca-certificates.crt

  # for VDR-LIVE
  # mkdir -p $INSTALL/usr/config/ssl
  # cp $PKG_DIR/config/openssl.cnf $INSTALL/usr/config/ssl
  # ln -sf /storage/.config/ssl/openssl.cnf $INSTALL/etc/ssl/openssl.cnf
}
