PKG_NAME="iperf"
PKG_VERSION="3.7"
PKG_SHA256="d846040224317caf2f75c843d309a950a7db23f9b44b94688ccbe557d6d1710c"
PKG_SITE="http://downloads.es.net/pub/iperf/?C=M;O=D"
PKG_URL="http://downloads.es.net/pub/iperf/iperf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fomit-frame-pointer||g"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --without-openssl"

post_install () {
  enable_service iperf3.service
}