PKG_NAME="tor"
PKG_VERSION="0.2.9.10"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl zlib libevent libcap"
PKG_SECTION="security"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-gcc-hardening \
			      --disable-linker-hardening \
			      --enable-systemd \
			      --disable-asciidoc \
			      --disable-unittests \
			      --disable-seccomp \
			      --disable-libscrypt \
			      --disable-dependency-tracking \
			      --with-openssl-dir=$SYSROOT_PREFIX \
			      --enable-static-openssl \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$ROOT/$TOOLCHAIN \
			      --with-libevent-dir=$SYSROOT_PREFIX/usr \
			      --with-openssl-dir=$SYSROOT_PREFIX/usr \
			      --with-tor-user=tor \
			      --with-tor-group=tor"

post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/sh"
  add_group tor 990
  
  add_user privoxy x 990 990 "privoxyr" "/storage" "/bin/sh"
  add_group privoxy 990
  
  add_user squid x 990 990 "squid" "/storage" "/bin/sh"
  add_group squid 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}