PKG_NAME="vsftpd"
PKG_VERSION="3.0.3"
PKG_URL="https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain libsodium libevent"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --prefix=/usr --sysconfdir=/storage/.config"