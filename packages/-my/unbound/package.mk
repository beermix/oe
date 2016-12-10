PKG_NAME="unbound"
PKG_VERSION="7e91dea"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat libevent openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#export LIBS="-lexpat"
#export LDFLAGS="-s -lexpat"

#PKG_CONFIGURE_OPTS_TARGET="--with-libunbound-only --disable-shared --enable-static --with-pthreads --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="--with-pthreads \
			      --enable-static \
			      --disable-shared \
			      --with-gnu-ld \
			      --sysconfdir=/storage/.config \
			      --with-libevent=$SYSROOT_PREFIX/usr \
			      --with-libunbound-only"
#		
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
