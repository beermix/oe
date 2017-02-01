PKG_NAME="coreutils"
PKG_VERSION="8.26"
PKG_URL="http://ftpmirror.gnu.org/coreutils/coreutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain acl attr libcap readline gmp openssl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--with-gmp \
			      --without-selinux \
			      --with-openssl \
			      --disable-rpath \
			      --enable-no-install-program=hostname,su,kill,uptime,uname,mv,mkdir,pwd,readlink,seq"