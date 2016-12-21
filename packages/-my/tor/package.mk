PKG_NAME="tor"
PKG_VERSION="0.2.9.8"
PKG_URL="https://archive.torproject.org/tor-package-archive/tor-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libz libevent"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-openssl-dir=$SYSROOT_PREFIX/usr \
			      --enable-gcc-hardening \
			      --disable-unittests \
			      --disable-seccomp \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$ROOT/$TOOLCHAIN \
			      --disable-asciidoc"


post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/sh"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
