PKG_NAME="nzbhydra"
PKG_VERSION="0.2.233"
PKG_SHA256="70f10fb9c62538a58e2e9c08e3f3b14c46dc84aa366596c25ef8db57d2472d8e"
PKG_REV="2"
PKG_SITE="https://github.com/theotherp/nzbhydra"
PKG_URL="https://github.com/theotherp/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="NZBHydra"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: meta search for NZB indexers "
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a meta search for NZB indexers. It provides easy access to a number of raw and newznab based indexers. You can search all your indexers from one place and use it as indexer source for tools like Sonarr or CouchPotato."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/nzbhydra"

  cp -PR "$PKG_BUILD"/* \
         "$ADDON_BUILD/$PKG_ADDON_ID/nzbhydra"
}
