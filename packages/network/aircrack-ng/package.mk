PKG_NAME="aircrack-ng"
PKG_VERSION="1.2-rc1"
PKG_GIT_URL="https://github.com/aircrack-ng/aircrack-ng"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl libpcap openssl pcre libgpg-error usbutils iw"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"



PKG_MAKE_OPTS_TARGET="prefix=/usr sqlite=true LIBSQL="-lsqlite3,-lpthread" unstable=false ext_scripts=true pcre=true libnl=true HAVE_PCAP=yes"

PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"