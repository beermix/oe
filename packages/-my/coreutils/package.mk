PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap readline gmp openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--without-selinux \
			      --with-openssl \
			      --enable-install-program=cat chgrp chmod chown cp date dd df dir echo false ln ls mkdir mknod mv pwd rm rmdir vdir sleep stty sync touch true uname join"
			      
