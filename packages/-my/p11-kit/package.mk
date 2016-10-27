PKG_NAME="p11-kit"
PKG_VERSION="0.23.2"
PKG_URL="https://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux openssl libffi libtasn1"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="\
		--with-sysroot=$SYSROOT_PREFIX"
