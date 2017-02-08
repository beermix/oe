PKG_NAME="iperf"
PKG_VERSION="3.1.6"
PKG_SITE="https://iperf.fr/"
PKG_URL="http://downloads.es.net/pub/iperf/iperf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network/testing"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"