# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv) --with-data-packaging=archive \

PKG_NAME="icu"
PKG_VERSION="64.2"
PKG_SHA256="627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/icu4c/${PKG_VERSION}/icu4c-${PKG_VERSION//./_}-src.tgz"
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

pre_configure_target() {
  export LIBS="-latomic"
}

configure_package() {
  PKG_CONFIGURE_OPTS_TARGET="--enable-static \
  				 --disable-shared \
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
