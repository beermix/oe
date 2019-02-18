PKG_NAME="coreutils"
PKG_VERSION="1.0.6"
PKG_URL="http://www.colordiff.org/colordiff-1.0.16.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses acl libunwind attr"
#PKG_DEPENDS_TARGET="toolchain ncurses grep openssl libcap attr libunwind"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"


#pre_configure_target() {
#  export LIBS="-lrt"
#}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --without-selinux \
			   --disable-nls \
			   --without-gmp \
			   --enable-no-install-program=hostname,su,kill,uptime,env,mkdir"