# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="openssl"
PKG_VERSION="1.0.2r"
PKG_SHA256="ae51d08bba8a83958e894946f15303ff894d75c2b8bbd44a852b64e3fe11d0d6"
PKG_LICENSE="BSD"
PKG_SITE="https://www.openssl.org/source/"
PKG_URL="https://www.openssl.org/source/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"

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
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED no-static-engine linux-x86_64 "-Wa,--noexecstack $CFLAGS $CPPFLAGS $LDFLAGS"
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
