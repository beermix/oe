PKG_NAME="openssl"
PKG_VERSION="1.0.2l"
PKG_URL="https://www.openssl.org/source/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain yasm:host pcre zlib gmp"
PKG_SECTION="security"
PKG_SHORTDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_SHARED="--openssldir=/etc/ssl \
                           --libdir=lib \
                           shared \
                           threads \
                           no-rfc3779 \
                           no-ssl2 \
                           no-ssl3 \
                           no-rc5 \
                           enable-camellia \
                           enable-mdc2 \
                           enable-tlsext \
                           enable-unit-test \
                           no-krb5 \
                           no-gmp \
                           no-zlib-dynamic \
                           no-zlib \
                           enable-ec_nistp_64_gcc_128"

pre_configure_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  export CCACHE_RECACHE=1
  ./Configure --prefix=/ $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 $HOST_CFLAGS
}

makeinstall_host() {
  export CCACHE_RECACHE=1
  make INSTALL_PREFIX=$ROOT/$TOOLCHAIN install_sw -j1
}

pre_configure_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME/
  
  #sed -i -e '/^"linux-x86_64"/ s/-m64 -DL_ENDIAN -O3 -Wall//' $ROOT/$PKG_BUILD/.$TARGET_NAME/Configure
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
  export CCACHE_RECACHE=1
  strip_lto
  strip_gold
}

configure_target() {
  cd $ROOT/$PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 $CFLAGS $CPPFLAGS
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

  $STRIP $INSTALL/usr/bin/openssl

  # create new cert: ./mkcerts.sh
  # cert from https://curl.haxx.se/docs/caextract.html
  
  mkdir -p $INSTALL/etc/ssl
  #perl $PKG_DIR/cert/mk-ca-bundle.pl
  #cp $ROOT/$PKG_BUILD/.$TARGET_NAME/ca-bundle.crt $INSTALL/etc/ssl/cert.pem
  cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cert.pem

  # backwards comatibility
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt
  mkdir -p $INSTALL/usr/lib/ssl
    ln -sf /etc/ssl/cert.pem $INSTALL/usr/lib/ssl/cert.pem

  #for VDR-LIVE
  # mkdir -p $INSTALL/usr/config/ssl
  # cp $PKG_DIR/config/openssl.cnf $INSTALL/usr/config/ssl
  # ln -sf /storage/.config/ssl/openssl.cnf $INSTALL/etc/ssl/openssl.cnf
}
