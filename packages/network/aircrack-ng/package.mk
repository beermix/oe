PKG_NAME="aircrack-ng"
PKG_VERSION="1.2-rc4"
#PKG_VERSION="177ee2c"
PKG_GIT_URL="https://github.com/aircrack-ng/aircrack-ng"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl libpcap openssl pcre libgpg-error usbutils iw"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  #export LDFLAGS="-ldl -lpthread -lsqlite3"
  export MAKEFLAGS="-j1"
}

#PKG_MAKE_OPTS_TARGET="prefix=/usr sqlite=true unstable=false ext_scripts=true pcre=true libnl=true"
PKG_MAKE_OPTS_TARGET="prefix=/usr libnl=true sqlite=false unstable=false OSNAME=Linux"

PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"