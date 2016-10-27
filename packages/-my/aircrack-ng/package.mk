PKG_NAME="aircrack-ng"
PKG_VERSION="4d3d0cc"
PKG_GIT_URL="https://github.com/aircrack-ng/aircrack-ng"
PKG_KEEP_CHECKOUT="yes"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl-tiny libpcap openssl pcre libgpg-error usbutils iw"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  LDFLAGS="$LDFLAGS -lpthread -lm"
  strip_lto
  #CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/libnl-tiny"
}

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

PKG_MAKE_OPTS_TARGET="prefix=/usr CROSS_COMPILE=$TARGET_PREFIX sqlite=false LIBSQL="-lsqlite3" experimental=true ext_scripts=true pcre=true libnl=true"

PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

# sqlit9:06 26.08.2016e=false 