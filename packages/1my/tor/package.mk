PKG_NAME="tor"
PKG_VERSION="0.4.0.5"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl zlib libevent libcap"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-systemd \
			      --disable-asciidoc \
			      --disable-unittests \
			      --disable-seccomp \
			      --disable-libscrypt \
			      --disable-largefile \
			      --disable-zstd \
			      --disable-lzma \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$SYSROOT_PREFIX \
			      --with-openssl-dir=$SYSROOT_PREFIX \
			      --with-libevent-dir=$SYSROOT_PREFIX \
			      --with-openssl-dir=$SYSROOT_PREFIX"

post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/sh"
  add_group tor 990
  
  add_user privoxy x 990 990 "privoxyr" "/storage" "/bin/sh"
  add_group privoxy 990
  
  add_user squid x 990 990 "squid" "/storage" "/bin/sh"
  add_group squid 990
  
  enable_service tor.service
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}