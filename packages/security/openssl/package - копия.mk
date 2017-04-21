PKG_NAME="openssl"
#PKG_VERSION="e8f2e2f"
#PKG_SITE="https://github.com/openssl/openssl/tree/OpenSSL_1_0_2-stable"
#PKG_GIT_URL="https://github.com/openssl/openssl"
#PKG_GIT_BRANCH="OpenSSL_1_0_2-stable"
PKG_VERSION="1.0.2k"
PKG_URL="https://www.openssl.org/source/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain pcre gmp"
PKG_SECTION="security"
PKG_SHORTDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_SHARED="--openssldir=/etc/ssl \
                           --libdir=lib \
                           shared \
                           threads \
                           no-rfc3779 \
                           no-ssl2 \
                           no-ssl3 \
                           enable-unit-test \
                           enable-tlsext \
                           no-zlib \
                           zlib-dynamic \
                           enable-ec_nistp_64_gcc_128"

pre_configure_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  ./Configure --prefix=/ $PKG_CONFIGURE_OPTS_SHARED_HOST linux-x86_64 $CFLAGS $LDFLAGS
}

makeinstall_host() {
  make -j1 INSTALL_PREFIX=$ROOT/$TOOLCHAIN install_sw
}


pre_configure_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $ROOT/$PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 $CFLAGS $LDFLAGS
}

makeinstall_target() {
  make -j1 INSTALL_PREFIX=$INSTALL install_sw
  make -j1 INSTALL_PREFIX=$SYSROOT_PREFIX install_sw
  chmod 755 $INSTALL/usr/lib/*.so*
  chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/ssl/misc
  rm -rf $INSTALL/usr/bin/c_rehash

  # cert from https://curl.haxx.se/docs/caextract.html
  mkdir -p $INSTALL/etc/ssl
    cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cert.pem

  # backwards comatibility
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt
  mkdir -p $INSTALL/usr/lib/ssl
    ln -sf /etc/ssl/cert.pem $INSTALL/usr/lib/ssl/cert.pem
}
