PKG_NAME="tor"
PKG_VERSION="1243c10"
PKG_GIT_URL="https://github.com/torproject/tor.git"
PKG_DEPENDS_TARGET="toolchain openssl libz libevent libcap"
PKG_SECTION="security"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="--disable-gcc-hardening \
			      --disable-linker-hardening \
			      --enable-systemd \
			      --disable-asciidoc \
			      --disable-unittests \
			      --disable-seccomp \
			      --sysconfdir=/storage/.config \
			      --datarootdir=/storage/.cache/tor \
			      --datadir=/storage/.cache/tor \
			      --with-zlib-dir=$TOOLCHAIN \
			      --with-libevent-dir=$SYSROOT_PREFIX/usr \
			      --with-openssl-dir=$SYSROOT_PREFIX/usr"


post_install() {
  add_user tor x 990 990 "Tor Server" "/storage" "/bin/bash"
  add_group tor 990
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
#ac_cv_prog_cc_c99=-std=gnu99