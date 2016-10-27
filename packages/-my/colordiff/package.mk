PKG_NAME="coreutils"
PKG_VERSION="1.0.6"
PKG_URL="http://www.colordiff.org/colordiff-1.0.16.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain netbsd-curses acl libunwind attr"
#PKG_BUILD_DEPENDS_TARGET="toolchain netbsd-curses grep openssl libcap attr libunwind"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


#pre_configure_target() {
#  export LIBS="-lrt"
#}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --without-selinux \
			   --disable-nls \
			   --without-gmp \
			   --enable-no-install-program=hostname,su,kill,uptime,env,mkdir"