PKG_NAME="tor"
PKG_VERSION="0.2.8.9"
PKG_URL="https://archive.torproject.org/tor-package-archive/tor-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libz libevent"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

#CFLAGS="$CFLAGS -fPIC -std=gnu99"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --with-openssl-dir=$SYSROOT_PREFIX/usr \
			   --disable-gcc-hardening \
			   --disable-unittests \
			   --disable-seccomp \
			   --disable-gcc-hardening \
			   --sysconfdir=/storage/.config \
			   --datarootdir=/storage/.cache/tor \
			   --datadir=/storage/.cache/tor \
			   --with-zlib-dir=$ROOT/$TOOLCHAIN \
			   --disable-asciidoc \
			   ac_cv_prog_cc_c99=-std=gnu99"


post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/bash"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}