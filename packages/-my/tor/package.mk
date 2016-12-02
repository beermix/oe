PKG_NAME="tor"
PKG_VERSION="maint-0.2.8"
PKG_GIT_URL="https://github.com/torproject/tor"
PKG_DEPENDS_TARGET="toolchain libz libevent"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
   CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

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
			      --disable-silent-rules \
			      ac_cv_prog_cc_c99=-std=gnu99"


post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/bash"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
