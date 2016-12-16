PKG_NAME="tor"
PKG_VERSION="maint-0.2.8"
PKG_GIT_URL="https://github.com/torproject/tor"
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
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/bash"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
