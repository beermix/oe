PKG_NAME="aria2"
PKG_VERSION="release-1.28.0"
PKG_GIT_URL="https://github.com/aria2/aria2"
PKG_DEPENDS_TARGET="toolchain libssh2 expat pcre curl libuv jemalloc libev gnutls"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-static \
			   --sysconfdir="/storage/.config" \
                           --datadir="/storage/.config" \
                           --libdir="/storage/.config" \
                           --libexecdir="/storage/.config" \
			   --disable-shared  \
			   --enable-silent-rules \
			   --with-sysroot=$SYSROOT_PREFIX \
			   --without-libnettle \
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
			   --without-xmltest \
			   --without-libxml2 \
			   --without-libcares \
			   --with-random=/dev/urandom \
			   --with-ca-bundle=/etc/ssl/cert.pem"
			   
# libidn