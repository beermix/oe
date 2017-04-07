PKG_NAME="unbound"
PKG_VERSION="b75911c"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#pre_configure_target() {
#  strip_gold
#  strip_lto
#}


PKG_CONFIGURE_OPTS_TARGET="--with-pthreads \
			      --disable-dsa \
			      --disable-gost \
			      --enable-allsymbols \
			      --enable-cachedb \
			      --enable-dnscrypt \
			      --disable-shared \
			      --sysconfdir=/storage/.config \
			      --with-libevent=$SYSROOT_PREFIX/usr \
			      --with-libsodium=$SYSROOT_PREFIX/usr \
			      --with-libexpat=$SYSROOT_PREFIX/usr \
			      --with-ssl=$SYSROOT_PREFIX/usr"
#		
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
