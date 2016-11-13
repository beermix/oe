PKG_NAME="openssl"
PKG_VERSION="1.0.2j"
PKG_URL="https://www.openssl.org/source/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz gmp pcre"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export MAKEFLAGS="-j1"
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O2||g"`
  #export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
}

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
              enable-tlsext \
              enable-ec_nistp_64_gcc_128 \
              enable-gmp \
              no-ssl3-method \
              linux-x86_64 \
              "-pthread -m64 -DL_ENDIAN -Wa,--noexecstack"
}

make_target() {
  make CC="$CC" \
       AR="$AR r" \
       LD="$LD -ldl" \
       XCFLAGS="$CFLAGS" \
       RANLIB="$RANLIB" \
       XLDFLAGS="$LDFLAGS" \
       MAKEDEPPROG="$CC" \
       depend all build-shared
}

makeinstall_target() {
  make INSTALL_PREFIX=$SYSROOT_PREFIX install_sw
  make INSTALL_PREFIX=$INSTALL install_sw
  chmod 755 $INSTALL/usr/lib/*.so*
  chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/pki/tls/misc
  rm -rf $INSTALL/usr/bin/c_rehash
  #$STRIP $INSTALL/usr/bin/openssl
  
# ca-certification: provides a tool to download and create ca-bundle.crt
# download url: http://curl.haxx.se
# create new cert: perl ./mk-ca-bundle.pl
  #mkdir -p $INSTALL/$SSL_CERTIFICATES
  perl $PKG_DIR/cert/mk-ca-bundle.pl
  mkdir -p $INSTALL/etc/ssl
  
  #cp $PKG_DIR/cert/ca-bundle.crt $INSTALL/$SSL_CERTIFICATES/cacert.pem
  cp $PKG_DIR/cert/ca-bundle.crt $INSTALL/etc/ssl/cert.pem
}
