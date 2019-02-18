PKG_NAME="ModemManager"
PKG_VERSION="1.6.2"
PKG_URL="https://www.freedesktop.org/software/ModemManager/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libgudev" 
PKG_SECTION="my"



PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --without-mbim \
			      --without-qmi"