PKG_NAME="unbound"
PKG_VERSION="6e870c3"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat libevent openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--with-pthreads \
			      --enable-static \
			      --disable-shared \
			      --sysconfdir=/storage/.config \
			      --with-libevent=$SYSROOT_PREFIX/usr"
#		
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
