PKG_NAME="iperf"
PKG_VERSION="3.1-STABLE"
PKG_SITE="https://iperf.fr/"
PKG_GIT_URL="https://github.com/esnet/iperf"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="network/testing"
PKG_SHORTDESC="iperf: A modern alternative for measuring maximum TCP and UDP bandwidth performance"
PKG_LONGDESC="Iperf was developed by NLANR/DAST as a modern alternative for measuring maximum TCP and UDP bandwidth performance. Iperf allows the tuning of various parameters and UDP characteristics. Iperf reports bandwidth, delay jitter, datagram loss."
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"