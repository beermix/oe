PKG_NAME="headphones"
PKG_VERSION="da9287d"
PKG_SHA256="78108b833681c2df0c94272d2e8754e0f31daa3a1d4b6006306421f30bed4f7a"
PKG_REV="19"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/rembo10/headphones"
PKG_URL="https://github.com/rembo10/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain python_common"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Headphones"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: automated music downloader for NZB and Torrent"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is an automated music downloader for NZB and Torrent. It supports SABnzbd, NZBget, Transmission, µTorrent, Deluge and Blackhole."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="manual"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/headphones

  cp -PR $PKG_BUILD/* \
         $ADDON_BUILD/$PKG_ADDON_ID/headphones 

  cp -PR "$(get_build_dir python_common)/.install_pkg/usr/lib" \
         "$ADDON_BUILD/$PKG_ADDON_ID"
}
