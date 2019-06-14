# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="audio-tools"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain alsa-plugins"
PKG_SECTION="service"
PKG_SHORTDESC="Audio Tools: audio tools"
PKG_LONGDESC="Audio Tools ($PKG_REV) provides ALSA plugins and sets up an audio device."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Audio Tools"
PKG_ADDON_TYPE="xbmc.service.library"
PKG_MAINTAINER="Anton Voyl (awiouy)"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/lib"
    cp "$(get_build_dir alsa-plugins)/.install_pkg/usr/lib/alsa"/*.so \
	     "$ADDON_BUILD/$PKG_ADDON_ID/lib"
}
