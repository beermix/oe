PKG_NAME="mlocate"
PKG_VERSION="0.26"
PKG_URL="https://fedorahosted.org/releases/m/l/mlocate/mlocate-0.26.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libiconv"
PKG_SECTION="my"



pre_configure_target() {
  export LDFLAGS="-ldl -lpthread -lsqlite3"
}

PKG_CONFIGURE_OPTS_TARGET="--localstatedir=/storage/.config --sysconfdir=/storage/.config"
