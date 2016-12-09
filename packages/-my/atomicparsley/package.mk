PKG_NAME="atomicparsley"
PKG_VERSION="master"
PKG_GIT_URL="https://bitbucket.org/wez/atomicparsley"
PKG_DEPENDS_TARGET="toolchain expat flex libevent openssl"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"



PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"
