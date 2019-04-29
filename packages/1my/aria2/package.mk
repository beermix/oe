PKG_NAME="aria2"
PKG_VERSION="ecba262"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_URL="https://github.com/aria2/aria2/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv"
PKG_TOOLCHAIN="autotools"

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
                           --with-ca-bundle=/etc/ssl/cacert.pem \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --without-libgcrypt \
                           --with-sqlite3 \
                           --with-libxml2"