PKG_NAME="tor"
PKG_VERSION="5d87e0e"
PKG_GIT_URL="https://github.com/torproject/tor"
PKG_GIT_BRANCH="maint-0.2.9"
PKG_DEPENDS_TARGET="toolchain libz libevent"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

CFLAGS="$CFLAGS -fPIC -std=gnu99"

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
