PKG_NAME="libpcap"
PKG_VERSION="1.9.1"
PKG_SHA256="635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094"
PKG_URL="http://www.tcpdump.org/release/libpcap-$PKG_VERSION.tar.gz"
PKG_SITE="https://github.com/the-tcpdump-group/libpcap"
#PKG_URL="https://github.com/the-tcpdump-group/libpcap/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_SHORTDESC="system interface for user-level packet capture"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="LIBS=-lpthread \
                           ac_cv_header_libusb_1_0_libusb_h=no \
                           --with-pcap=linux \
                           --disable-bluetooth \
                           --disable-can \
                           --without-libnl \
                           --disable-dbus \
                           --disable-canusb"

pre_configure_target() {
# When cross-compiling, configure can't set linux version
# forcing it
  sed -i -e 's/ac_cv_linux_vers=unknown/ac_cv_linux_vers=2/' ../configure
  CFLAGS="$CFLAGS -D_DEFAULT_SOURCE"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
