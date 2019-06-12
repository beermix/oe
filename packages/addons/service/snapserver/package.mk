# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="snapserver"
PKG_VERSION="0.15.0"
PKG_REV="103"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_DEPENDS_TARGET="toolchain snapcast"
PKG_SECTION="service"
PKG_SHORTDESC="Snapserver: Synchronous multi-room audio server"
PKG_LONGDESC="SnapServer ($PKG_VERSION) is a Snapcast server. Snapcast is a multi-room client-server audio system, where all clients are time synchronized with the server to play perfectly synced audioplays."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Snapserver"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="Anton Voyl (awiouy)"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/bin"
  cp "$(get_build_dir snapcast)/server/snapserver" \
     "$ADDON_BUILD/$PKG_ADDON_ID/bin"
}
