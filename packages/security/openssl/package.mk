###############################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################
PKG_NAME="openssl"
PKG_VERSION="1.0.2l"
PKG_URL="https://www.openssl.org/source/openssl-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host yasm:host"
PKG_DEPENDS_TARGET="toolchain pcre gmp zlib"
PKG_SECTION="security"
PKG_SHORTDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"
PKG_LONGDESC="The Open Source toolkit for Secure Sockets Layer and Transport Layer Security"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CONCURRENCY_MAKE_LEVEL=1
CCACHE_DISABLE=1

PKG_CONFIGURE_OPTS_SHARED="--openssldir=/etc/ssl \
                           --libdir=lib \
                           shared \
                           threads \
                           no-ec2m \
                           no-ssl2 \
                           no-ssl3 \
                           no-jpake \
                           no-krb5 \
                           no-sctp \
                           no-ssl-trace \
                           no-libunbound \
                           no-md2 \
                           no-store \
                           enable-unit-test \
                           enable-tlsext \
                           no-weak-ssl-ciphers \
                           no-zlib \
                           no-zlib-dynamic \
                           enable-ec_nistp_64_gcc_128"

pre_configure_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME/
  
  sed -i -e '/^"linux-x86_64"/ s/-m64 -DL_ENDIAN -O3 -Wall//' $ROOT/$PKG_BUILD/.$HOST_NAME/Configure
}

configure_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  ./Configure --prefix=/ $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 $CFLAGS $LDFLAGS
}

makeinstall_host() {
  make INSTALL_PREFIX=$ROOT/$TOOLCHAIN install_sw
}


pre_configure_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -a $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME/
  
  sed -i -e '/^"linux-x86_64"/ s/-m64 -DL_ENDIAN -O3 -Wall//' $ROOT/$PKG_BUILD/.$TARGET_NAME/Configure
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  strip_lto
}

configure_target() {
  cd $ROOT/$PKG_BUILD/.$TARGET_NAME
  ./Configure --prefix=/usr $PKG_CONFIGURE_OPTS_SHARED linux-x86_64 -DL_ENDIAN -Wall $CFLAGS $CPPFLAGS  -Wa,--noexecstack
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

 # debug_strip $INSTALL/usr/bin/openssl

  # create new cert: ./mkcerts.sh
  mkdir -p $INSTALL/etc/ssl
    cp $PKG_DIR/cert/ca-bundle.crt $INSTALL/etc/ssl/cert.pem

  # backwards comatibility
  mkdir -p $INSTALL/etc/pki/tls
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/cacert.pem
  mkdir -p $INSTALL/etc/pki/tls/certs
    ln -sf /etc/ssl/cert.pem $INSTALL/etc/pki/tls/certs/ca-bundle.crt
  mkdir -p $INSTALL/usr/lib/ssl
    ln -sf /etc/ssl/cert.pem $INSTALL/usr/lib/ssl/cert.pem
 # cp $PKG_DIR/config/openssl.cnf $INSTALL/etc/pki/tls/openssl.cnf
}
