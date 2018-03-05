PKG_NAME="iperf"
PKG_VERSION="3.4"
PKG_SITE="http://downloads.es.net/pub/iperf/?C=M;O=D"
PKG_URL="http://downloads.es.net/pub/iperf/iperf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network/testing"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared"

#post_install () {
#  enable_service iperf3.service
#}