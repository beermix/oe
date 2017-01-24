PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap readline openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-nls \
			      --without-gmp \
			      --enable-no-install-program=hostname,su,kill,uptime \
			      --without-selinux \
			      --with-openssl \
			      --disable-rpath \
			      --enable-install-program=cat,chgrp,chmod,chown,cp,date,dd"