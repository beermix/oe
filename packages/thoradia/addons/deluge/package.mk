PKG_NAME="deluge"
PKG_VERSION="1.3.15"
PKG_SHA256="6f2accf55bd97828f81ea13d5f29087103eb4f95b6be957323e23174cdc86826"
PKG_REV="25"
PKG_LICENSE="GPLv3"
PKG_SITE="http://deluge-torrent.org/"
PKG_URL="https://github.com/deluge-torrent/deluge/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="deluge-deluge-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain cffi libtorrent-rasterbar"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Deluge"
PKG_ADDON_TYPE="xbmc.service"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: lightweight, free software, cross-platform BitTorrent client"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a lightweight, free software, cross-platform BitTorrent client."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="python2"

pre_make_target() {
  export LDSHARED="-pthread"
  python setup.py build
}

post_make_target() {
  _site="usr/lib/$PKG_PYTHON_VERSION/site-packages"
  cp -r "$(get_build_dir cffi)/.install_pkg/$_site"/cffi-*.egg \
         "$INSTALL/$_site"
  cat "$(get_build_dir cffi)/.install_pkg/$_site/easy-install.pth" >> "$INSTALL/$_site/easy-install.pth"
}

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/bin"

  cp -PR "$PKG_BUILD/.install_pkg/usr/lib" \
         "$ADDON_BUILD/$PKG_ADDON_ID"

  cp -LR "$(get_build_dir libtorrent-rasterbar)/.install_pkg/usr/lib"/libtorrent-rasterbar.so.? \
         "$(get_build_dir libtorrent-rasterbar)/.install_pkg/usr/lib/$PKG_PYTHON_VERSION" \
         "$ADDON_BUILD/$PKG_ADDON_ID/lib"
}
