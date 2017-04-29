PKG_NAME="aria2"
PKG_VERSION="a283960"
PKG_GIT_URL="https://github.com/aria2/aria2"
PKG_DEPENDS_TARGET="toolchain expat gmp pcre curl libuv libev openssl xmlstarlet libxml2 libssh2"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --with-ca-bundle=/etc/ssl/cert.pem \
                           --with-openssl \
                           --without-gnutls \
                           --disable-ipv6 \
                           --with-libgmp \
                           --with-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libz \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-xmltest \
                           --with-libxml2 \
                           --without-libcares \
                           --with-libexpat \
                           --enable-largefile"