PKG_NAME="tor"
PKG_VERSION="0.2.9.8"
PKG_URL="https://archive.torproject.org/tor-package-archive/tor-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libz libevent libcap"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -std=gnu99"
}

PKG_CONFIGURE_OPTS_TARGET="--with-openssl-dir=$SYSROOT_PREFIX/usr \
			      --disable-gcc-hardening \
			      --disable-unittests \
			      --disable-seccomp \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$ROOT/$TOOLCHAIN \
			      --with-libevent-dir=$SYSROOT_PREFIX/usr \
			      --disable-asciidoc"


post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/sh"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
