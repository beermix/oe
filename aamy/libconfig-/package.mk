PKG_NAME="libconfig"
PKG_VERSION="1.5"
PKG_URL="https://dl.dropboxusercontent.com/s/puncraq3wyy412z/libconfig-1.5.tar.gz"
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
			   --enable-static \
			   --disable-shared"