# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) --with-data-packaging=archive \

PKG_NAME="icu"
PKG_VERSION="65.1"
PKG_SHA256="53e37466b3d6d6d01ead029e3567d873a43a5d1c668ed2278e253b683136d948"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/icu4c/${PKG_VERSION}/icu4c-${PKG_VERSION//./_}-src.tgz"
PKG_URL="https://fossies.org/linux/misc/icu4c-65_1-src.tgz"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_LONGDESC="International Components for Unicode library."
PKG_BUILD_FLAGS="+pic"

post_unpack() {
  mv $PKG_BUILD/source/* $PKG_BUILD
  rmdir $PKG_BUILD/source
}

post_configure_host() {
  # we are not in source folder
  sed -i 's|../LICENSE|LICENSE|' Makefile
}

post_configure_target() {
  # we are not in source folder
  sed -i 's|../LICENSE|LICENSE|' Makefile
}

#pre_configure_target() {
#  export LIBS="-latomic"
#}

configure_package() {
  PKG_CONFIGURE_OPTS_TARGET="--disable-samples \
  				 --disable-tests \
  				 --disable-shared \
  				 --enable-static \
  				 --with-data-packaging=archive \
  				 --with-cross-build=$(get_build_dir $PKG_NAME)/.$HOST_NAME"
}

makeinstall_host() {
 : # nothing todo
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/usr/lib/icu
  rm -rf $INSTALL
}
