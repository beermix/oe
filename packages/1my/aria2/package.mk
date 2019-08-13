PKG_NAME="aria2"
PKG_VERSION="1.34.0"
PKG_SHA256="3a44a802631606e138a9e172a3e9f5bcbaac43ce2895c1d8e2b46f30487e77a3"
#PKG_VERSION="7f6578a"
PKG_SITE="https://github.com/aria2/aria2/releases"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/aria2/aria2/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre curl libev libxml2 libuv c-ares"
PKG_TOOLCHAIN="configure"

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
                           --with-ca-bundle=/run/libreelec/cacert.pem \
                           --with-libexpat \
                           --with-zlib \
                           --with-libuv \
                           --with-libcares \
                           --without-libgcrypt \
                           --with-sqlite3 \
                           --with-libxml2 \
                           ARIA2_STATIC=yes"