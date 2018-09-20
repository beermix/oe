PKG_NAME="rutorrent"
PKG_VERSION="3.8"
PKG_SHA256="610fc5df350fe7915b4413067fea8657eb6f26b1cc5212de97a4af98439b2e2c"
PKG_REV="8"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/Novik/ruTorrent"
PKG_URL="https://github.com/Novik/ruTorrent/archive/v$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="ruTorrent-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain mediainfo php unrar"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="ruTorrent"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REQUIRES="service.rtorrent:0.0.0"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: web front-end for rTorrent"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a web front-end for rtorrent designed to emulate the look and feel of µTorrent web user interface."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/bin"
  cp "$(get_build_dir php)/.install_pkg/usr/bin/php" \
     "$(get_build_dir mediainfo)/Project/GNU/CLI/mediainfo" \
     "$(get_build_dir unrar)/unrar" \
     "$ADDON_BUILD/$PKG_ADDON_ID/bin"

  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/rutorrent"
  cp -R "$PKG_BUILD"/* \
        "$ADDON_BUILD/$PKG_ADDON_ID/rutorrent"
}
