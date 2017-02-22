PKG_NAME="coreutils"
PKG_VERSION="8.25"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap pcre readline openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="PERL=missing \
			      MAKEINFO=missing \
			      --disable-nls \
			      --without-gmp \
			      --enable-no-install-program=hostname,su,kill,uptime,md5sum \
			      --without-selinux \
			      --with-openssl \
			      --disable-rpath \
			      --enable-threads=posix \
			      --enable-install-program=cat,chgrp,chmod,chown,cp,date,dd"