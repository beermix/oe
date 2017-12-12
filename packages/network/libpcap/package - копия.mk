PKG_NAME="libpcap"
#PKG_VERSION="libpcap-1.8.1"
PKG_VERSION="d61d4ed"
PKG_GIT_URL="https://github.com/the-tcpdump-group/libpcap"
PKG_DEPENDS_TARGET="toolchain libz"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="LIBS=-lpthread \
                           ac_cv_header_libusb_1_0_libusb_h=no \
                           --disable-shared \
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
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

#PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=OFF"
