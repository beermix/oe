PKG_NAME="tor"
PKG_VERSION="4a2afd5"
PKG_GIT_URL="https://github.com/torproject/tor.git"
PKG_DEPENDS_TARGET="toolchain openssl zlib libevent libcap"
PKG_SECTION="security"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-gcc-hardening \
			      --disable-linker-hardening \
			      --enable-systemd \
			      --disable-asciidoc \
			      --disable-unittests \
			      --enable-static-zlib \
			      --disable-seccomp \
			      --with-openssl-dir=$SYSROOT_PREFIX \
			      --enable-static-openssl \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$ROOT/$TOOLCHAIN \
			      --with-libevent-dir=$SYSROOT_PREFIX/usr \
			      --with-openssl-dir=$SYSROOT_PREFIX/usr"

post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/sh"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}