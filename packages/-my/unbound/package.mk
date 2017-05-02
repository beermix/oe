PKG_NAME="unbound"
PKG_VERSION="1.6.2"
PKG_URL="https://fossies.org/linux/misc/dns/unbound-1.6.2.tar.xz"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-libevent=$SYSROOT_PREFIX/usr \
			      --with-libsodium=$SYSROOT_PREFIX/usr \
			      --with-libexpat=$SYSROOT_PREFIX/usr \
			      --with-ssl=$SYSROOT_PREFIX/usr"
#		
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
