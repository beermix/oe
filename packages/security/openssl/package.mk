# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="openssl"
PKG_VERSION="1.0.2p"
PKG_SHA256="50a98e07b1a89eb8f6a99477f262df71c6fa7bef77df4dc83025a2845c827d00"
PKG_LICENSE="BSD"
PKG_SITE="https://www.openssl.org/source/"
PKG_URL="https://www.openssl.org/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="yasm:host"
PKG_DEPENDS_TARGET="toolchain yasm:host zlib"
PKG_SHORTDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_BUILD_FLAGS="+hardening"

PKG_CONFIGURE_OPTS_SHARED="--openssldir=/etc/ssl \
                           --libdir=lib \
                           shared \
                           threads \
                           enable-camellia \
                           enable-mdc2 \
                           enable-unit-test \
                           no-ssl3-method \
                           enable-ec_nistp_64_gcc_128"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./Configure --prefix=/ $PKG_CONFIGURE_OPTS_SHARED no-zlib no-zlib-dynamic no-static-engine linux-x86_64
  #  "-Wa,--noexecstack $CFLAGS $LDFLAGS -ffunction-sections -fdata-sections -Wl,--gc-sections"
}

makeinstall_host() {
  make INSTALL_PREFIX=$TOOLCHAIN install_sw -j1
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
  
#  sed -i -e '/^"linux-x86_64"/ s/-m64 -DL_ENDIAN -O3 -Wall//' $PKG_BUILD/.$TARGET_NAME/Configure
#  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
#  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED no-static-engine linux-x86_64 $CFLAGS $CPPFLAGS $LDFLAGS
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
  cp $PKG_DIR/scripts/openssl-config $INSTALL/usr/bin
  cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cert.pem
  cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cacert.pem

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
