PKG_NAME="tor"
PKG_VERSION="0.2.8.12"
PKG_URL="https://archive.torproject.org/tor-package-archive/tor-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libz libevent libcap"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_cc_c99=-std=gnu99 \
			      --with-openssl-dir=$SYSROOT_PREFIX/usr \
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
