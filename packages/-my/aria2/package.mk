PKG_NAME="aria2"
PKG_VERSION="1.32.0"
PKG_URL="https://github.com/aria2/aria2/releases/download/release-$PKG_VERSION/aria2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat gmp pcre curl libuv libev openssl xmlstarlet libxml2"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
                           --with-ca-bundle=/etc/ssl/cert.pem \
                           --disable-ipv6 \
                           --enable-largefile \
                           --without-sqlite3"