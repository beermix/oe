PKG_NAME="tor"
PKG_VERSION="release-0.2.9"
PKG_URL="https://dl.dropboxusercontent.com/s/2blsjkv8nywrf5a/tor-release-0.2.9.tar.lrz"
PKG_DEPENDS_TARGET="toolchain openssl zlib libevent libcap"
PKG_SECTION="security"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-systemd \
			      --disable-asciidoc \
			      --disable-unittests \
			      --disable-seccomp \
			      --disable-libscrypt \
			      --with-openssl-dir=$SYSROOT_PREFIX \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$SYSROOT_PREFIX \
			      --with-libevent-dir=$SYSROOT_PREFIX \
			      --with-openssl-dir=$SYSROOT_PREFIX \
			      --with-tor-user=tor \
			      --with-tor-group=tor"

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