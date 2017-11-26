PKG_NAME="nagioslogserver"
PKG_VERSION=""
PKG_URL="https://assets.nagios.com/downloads/nagios-log-server/1/nagioslogserver-1.4.0.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain boost Python"

PKG_SECTION="devel"



pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
  strip_lto
}


configure_target() {
  cd $PKG_BUILD
  ./fullinstall

}


