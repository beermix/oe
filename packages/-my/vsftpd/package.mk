PKG_NAME="vsftpd"
PKG_VERSION="3.0.3"
PKG_URL="https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain libsodium libevent"

PKG_SECTION="my"

PKG_AUTORECONF="no"

CFLAGS="$CFLAGS -fPIC -DPIC"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --prefix=/usr --sysconfdir=/storage/.config"