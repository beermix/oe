PKG_NAME="p11-kit"
PKG_VERSION="0.23.7"
PKG_URL="https://github.com/p11-glue/p11-kit/releases/download/$PKG_VERSION/p11-kit-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux openssl libffi libtasn1"
PKG_SECTION="security"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-module-path=/usr/lib/pkcs11"
