PKG_NAME="aria2"
PKG_VERSION="c90ff13"
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
                           --disable-ipv6 \
                           --enable-largefile"