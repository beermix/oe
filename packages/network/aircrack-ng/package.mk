prPKG_NAME="aircrack-ng"
PKG_VERSION="b48d9a4"
PKG_GIT_URL="https://github.com/aircrack-ng/aircrack-ng"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl libpcap openssl pcre libgpg-error usbutils iw"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  strip_gold
  #export LDFLAGS="-ldl -pthread"
  CONCURRENCY_MAKE_LEVEL=1
}

#PKG_MAKE_OPTS_TARGET="prefix=/usr sqlite=true unstable=false ext_scripts=true pcre=true libnl=true"

PKG_MAKE_OPTS_TARGET="prefix=/usr libnl=false sqlite=false unstable=false pcre=true ext_scripts=true"

PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"