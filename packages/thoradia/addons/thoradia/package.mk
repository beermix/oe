PKG_NAME="thoradia"
PKG_REV="18"
PKG_SITE="https://github.com/thoradia/thoradia"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Thoradia Add-ons"
PKG_ADDON_TYPE="thoradia.service"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: add-on repository"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_REV) add-on repository, provides aria2, btfs, CouchPotato, Deluge, FlexGet, Headphones, Jackett, Lidarr, Medusa, NZBGet, NZBHydra, qBittorent, Radarr, rTorrent, ruTorrent, SABnzbd, Sonarr and Transmission."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID"
}
