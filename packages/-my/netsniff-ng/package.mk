PKG_NAME="netsniff-ng"
PKG_VERSION="4a4b85a"
PKG_GIT_URL="https://github.com/netsniff-ng/netsniff-ng"
PKG_DEPENDS_TARGET="toolchain netbsd-curses libdnet iptables libnl libpcap libsodium"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared"
