PKG_NAME="btfs"
PKG_VERSION="2.18"
PKG_SHA256="bb9679045540554232eff303fc4f615d28eb4023461eae3f65f08f2427ec9ef2"
PKG_REV="1"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/johang/btfs"
PKG_URL="https://github.com/johang/$PKG_NAME/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl fuse libtorrent-rasterbar"
PKG_TOOLCHAIN="autotools"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="btfs"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_MAINTAINER="thoradia"
PKG_SECTION="tools"
PKG_SHORTDESC="$PKG_ADDON_NAME: bittorrent filesystem based on FUSE"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a bittorrent filesystem based on FUSE."
PKG_DISCLAIMER="Keep it legal and carry on"

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/lib"

  cp -PR "$PKG_BUILD/.install_pkg/usr/bin" \
         "$ADDON_BUILD/$PKG_ADDON_ID"

  cp -LR "$(get_build_dir libtorrent-rasterbar)/.install_pkg/usr/lib"/libtorrent-rasterbar.so.? \
         "$ADDON_BUILD/$PKG_ADDON_ID/lib"
}
