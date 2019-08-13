# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) no-ssl3-method no-ssl2 no-ssl3

PKG_NAME="openssl"
#PKG_VERSION="1.0.2s"
#PKG_SHA256="cabd5c9492825ce5bd23f3c3aeed6a97f8142f606d893df216411f07d1abab96"
PKG_VERSION="d333eba"
PKG_LICENSE="BSD"
PKG_SITE="https://www.openssl.org/source/"
PKG_URL="https://www.openssl.org/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SITE="https://github.com/openssl/openssl/tree/OpenSSL_1_0_2-stable"
PKG_URL="https://github.com/openssl/openssl/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host nasm:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed"

PKG_CONFIGURE_OPTS_SHARED="--libdir=lib \
                           shared \
                           threads \
                           no-ec2m \
                           no-gmp \
                           no-jpake \
                           no-krb5 \
                           no-libunbound \
                           no-md2 \
                           no-rc5 \
                           no-rfc3779
                           no-sctp \
                           no-ssl-trace \
                           no-ssl2 \
                           no-ssl3 \
                           no-store \
                           no-unit-test \
                           no-weak-ssl-ciphers \
                           no-zlib \
                           no-zlib-dynamic \
                           no-static-engine \
                           enable-ec_nistp_64_gcc_128"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN \
                         --openssldir=$TOOLCHAIN/etc/ssl"
PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --openssldir=/etc/ssl"

post_unpack() {
  find $PKG_BUILD/apps -type f | xargs -n 1 -t sed 's|./demoCA|/etc/ssl|' -i
}

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./Configure $PKG_CONFIGURE_OPTS_HOST $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 "-Wa,--noexecstack $CFLAGS $LDFLAGS"
}

makeinstall_host() {
  make install_sw
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./Configure $PKG_CONFIGURE_OPTS_TARGET $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 "-Wa,--noexecstack $CFLAGS $LDFLAGS"
}

makeinstall_target() {
  make INSTALL_PREFIX=$INSTALL install_sw
  make INSTALL_PREFIX=$SYSROOT_PREFIX install_sw
  chmod 755 $INSTALL/usr/lib/*.so*
  chmod 755 $INSTALL/usr/lib/engines/*.so
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/ssl/misc
  rm -rf $INSTALL/usr/bin/c_rehash

  debug_strip $INSTALL/usr/bin/openssl

  # cert from https://curl.haxx.se/docs/caextract.html
  mkdir -p $INSTALL/etc/ssl
    cp $PKG_DIR/cert/cacert.pem $INSTALL/etc/ssl/cacert.pem.system

  # give user the chance to include their own CA
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/openssl-config $INSTALL/usr/bin
    ln -sf /run/libreelec/cacert.pem $INSTALL/etc/ssl/cacert.pem
    ln -sf /run/libreelec/cacert.pem $INSTALL/etc/ssl/cert.pem

  # backwards comatibility
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /run/libreelec/cacert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /run/libreelec/cacert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt
  mkdir -p $INSTALL/usr/lib/ssl
    ln -sf /run/libreelec/cacert.pem $INSTALL/usr/lib/ssl/cert.pem
}

post_install() {
  enable_service openssl-config.service
}
