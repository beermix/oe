PKG_NAME="openssl"
PKG_VERSION="1.1.0d"
PKG_URL="https://www.openssl.org/source/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib pcre"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


configure_target() {
  ./Configure --prefix=/usr \
              --libdir=lib \
              --openssldir=/etc/ssl \
              shared \
              threads \
              zlib-dynamic \
              enable-camellia \
              enable-seed \
              enable-rfc3779 \
              enable-cms \
              enable-mdc2 \
              enable-md2 \
              enable-ec \
              enable-ecdh \
              enable-ecdsa \
              no-rc5 \
              no-ssl3-method \
              no-idea \
              no-whirlpool \
              no-err \
              no-heartbeats \
              enable-ec_nistp_64_gcc_128 \
              debian-amd64
}

make_target() {
  make CC="$CC" \
       AR="$AR r" \
       LD="$LD -ldl" \
       XCFLAGS="$CFLAGS" \
       RANLIB="$RANLIB" \
       XLDFLAGS="$LDFLAGS" \
       MAKEDEPPROG="$CC" \
       all -j1
}

makeinstall_target() {
  make -f Makefile install_sw DESTDIR=$SYSROOT_PREFIX
  make -f Makefile DESTDIR=$INSTALL install_sw
  #make INSTALL_PREFIX=$SYSROOT_PREFIX install_sw
  #make INSTALL_PREFIX=$INSTALL install_sw
  #chmod 755 $INSTALL/usr/lib/*.so*
  #chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/pki/tls/misc
  rm -rf $INSTALL/usr/bin/c_rehash
  #$STRIP $INSTALL/usr/bin/openssl
  
# ca-certification: provides a tool to download and create ca-bundle.crt
# download url: http://curl.haxx.se
# create new cert: perl ./mk-ca-bundle.pl
  #mkdir -p $INSTALL/$SSL_CERTIFICATES
  mkdir -p $INSTALL/etc/ssl
  perl $PKG_DIR/cert/mk-ca-bundle.pl
  cp $ROOT/$PKG_BUILD/ca-bundle.crt $INSTALL/etc/ssl/cert.pem
    
  #cp $PKG_DIR/cert/ca-bundle.crt $INSTALL/etc/ssl/cert.pem
}
