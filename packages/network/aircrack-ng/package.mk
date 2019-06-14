prPKG_NAME="aircrack-ng"
PKG_VERSION="1.2-rc4"
PKG_URL="https://github.com/aircrack-ng/aircrack-ng/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libdnet libnl libpcap openssl pcre usbutils iw"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

#PKG_MAKE_OPTS_TARGET="prefix=/usr sqlite=true unstable=false ext_scripts=true pcre=true libnl=true"

PKG_MAKE_OPTS_TARGET="prefix=/usr libnl=false sqlite=true unstable=false pcre=true ext_scripts=true"

#PKG_MAKEINSTALL_OPTS_TARGET="$PKG_MAKE_OPTS_TARGET"

make_target() {
#  cd $PKG_BUILD
  make
}

make_install_target() {
#  cd $PKG_BUILD
  make install
}