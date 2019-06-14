PKG_NAME="lidarr"
PKG_VERSION="0.2.0.371"
PKG_SHA256="203de8058326e76e33a72c08e3c27d11564fe618a9e48989a694b3206fbafe52"
PKG_REV="5"
PKG_LICENSE="GPLv3"
PKG_SITE="http://lidarr.audio/"
PKG_URL="https://github.com/lidarr/Lidarr/releases/download/v0.2.0.371/Lidarr.develop.0.2.0.371.linux.tar.gz"
PKG_SOURCE_DIR="Lidarr"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Lidarr"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REQUIRES="virtual.thoradia-mono:0.0.0"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: a music collection manager for Usenet and BitTorrent users"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/Lidarr"
  cp -PR "$PKG_BUILD"/* "$ADDON_BUILD/$PKG_ADDON_ID/Lidarr"
}
