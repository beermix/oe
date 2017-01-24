PKG_NAME="aria2"
PKG_VERSION="1.31.0"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat gmp pcre curl libuv libev xmlstarlet libxml2 nettle gnutls libssh2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_taret() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --with-libnettle \
                           --without-openssl \
                           --disable-ipv6 \
                           --with-libgmp \
                           --with-gnutls \
                           --with-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-xmltest \
                           --with-libxml2 \
                           --without-libcares \
                           --with-ca-bundle=/etc/ssl/cert.pem"