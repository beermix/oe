PKG_NAME="iperf"
PKG_VERSION="3043c16"
PKG_SITE="https://github.com/esnet/iperf/tree/3.2-STABLE"
PKG_GIT_URL="https://github.com/esnet/iperf"
PKG_GIT_BRANCH="3.2-STABLE"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network/testing"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"

post_install () {
  enable_service iperf3.service
}