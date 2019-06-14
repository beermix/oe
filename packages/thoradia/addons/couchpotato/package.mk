PKG_NAME="couchpotato"
PKG_VERSION="0a97ed5"
PKG_SHA256="597ffec8d854bf195904bec7d5f44b13c97bdca6910742bdfbd8c91e4a6f5f83"
PKG_REV="21"
PKG_LICENSE="GPLv3"
PKG_SITE="http://couchpota.to"
PKG_URL="https://github.com/CouchPotato/CouchPotatoServer/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="CouchPotatoServer-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain python_common"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="CouchPotato"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: automatic movie downloading via Usenet and BitTorrent"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) downloads movies automatically, easily and in the best quality as soon as they are available."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/couchpotato"

  cp -PR "$PKG_BUILD"/* \
         "$ADDON_BUILD/$PKG_ADDON_ID/couchpotato"

  cp -PR "$(get_build_dir python_common)/.install_pkg/usr/lib" \
         "$ADDON_BUILD/$PKG_ADDON_ID"
}
