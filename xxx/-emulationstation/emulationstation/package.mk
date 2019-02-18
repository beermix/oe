################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="emulationstation"
PKG_VERSION="76c1538"
PKG_SITE="https://github.com/Herdinger/EmulationStation"
PKG_GIT_URL="https://github.com/Herdinger/EmulationStation"
PKG_SOURCE_DIR="EmulationStation*"
PKG_DEPENDS_TARGET="toolchain systemd SDL2 boost freetype curl cmake:host freeimage eigen"
PKG_SECTION="xmedia/games"
PKG_SHORTDESC="Emulationstation emulator frontend"



# theme for Emulationstation
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-simple-dark"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-carbon"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-carbon-nometa"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-pixel"
PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET emulationstation-theme-turtle-pi"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=1 \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_INSTALL_LIBDIR=/usr/lib \
        -DCMAKE_INSTALL_LIBDIR_NOARCH=/usr/lib \
        -DCMAKE_INSTALL_PREFIX_TOOLCHAIN=$SYSROOT_PREFIX/usr \
        -DCMAKE_PREFIX_PATH=$SYSROOT_PREFIX/usr \
        -DCMAKE_FIND_ROOT_PATH=$SYSROOT_PREFIX/usr \
        $EXTRA_CMAKE_OPTS"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/emulationstation
    cp $PKG_DIR/config/* $INSTALL/usr/config/emulationstation
}
