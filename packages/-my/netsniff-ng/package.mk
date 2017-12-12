PKG_NAME="netsniff-ng"
PKG_VERSION="4a4b85a"
PKG_GIT_URL="https://github.com/netsniff-ng/netsniff-ng"
PKG_DEPENDS_TARGET="toolchain ncurses libdnet iptables libnl libpcap libsodium"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared"
