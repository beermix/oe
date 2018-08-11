PKG_NAME="aria2"
PKG_VERSION="1.34.0"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv"
PKG_SECTION="tools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --without-libnettle \
                           --with-openssl \
                           --disable-ipv6 \
                           --without-gnutls \
                           --without-libssh2 \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --without-sqlite3 \
                           --with-libxml2 \
                           --with-ca-bundle=/etc/ssl/cacert.pem"