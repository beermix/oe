PKG_NAME="libconfig"
PKG_VERSION="1.5"
PKG_URL="https://dl.dropboxusercontent.com/s/puncraq3wyy412z/libconfig-1.5.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain ncurses acl libunwind attr"
#PKG_BUILD_DEPENDS_TARGET="toolchain ncurses grep openssl libcap attr libunwind"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


#pre_configure_target() {
#  export LIBS="-lrt"
#}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --without-selinux \
			   --disable-nls \
			   --enable-static \
			   --disable-shared"