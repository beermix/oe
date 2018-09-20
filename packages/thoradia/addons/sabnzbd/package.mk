PKG_NAME="sabnzbd"
PKG_VERSION="2.3.5"
PKG_SHA256="96dd1c7694b59f37d379150a6b652dc3fd58e2e487a92ece009e292db3c07e64"
PKG_REV="31"
PKG_LICENSE="GPLv2"
PKG_SITE="https://sabnzbd.org/"
PKG_URL="https://github.com/sabnzbd/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain p7zip par2cmdline python_sabnzbd unrar"
PKG_SECTION="service"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="SABnzbd"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REQUIRES="service.locale:0.0.0"
PKG_MAINTAINER="thoradia"
PKG_SHORTDESC="$PKG_ADDON_NAME: free and easy binary newsreader"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_VERSION) is a program to download binary files from Usenet servers."
PKG_DISCLAIMER="Keep it legal and carry on"

PKG_TOOLCHAIN="python2"

make_target() {
  rm -fr linux osx six win
  "$TOOLCHAIN/bin/python" tools/make_mo.py
  "$TOOLCHAIN/bin/python" "$TOOLCHAIN/lib/$PKG_PYTHON_VERSION/compileall.py" -q .
  find . -name "*.py" -exec rm -rf "{}" ";"
}

addon() {
  mkdir -p "$ADDON_BUILD/$PKG_ADDON_ID/bin" \
           "$ADDON_BUILD/$PKG_ADDON_ID/sabnzbd"

  cp -PR "$(get_build_dir p7zip)"/bin/* \
         "$(get_build_dir par2cmdline)/.install_pkg/usr/bin/par2" \
         "$(get_build_dir unrar)/unrar" \
         "$ADDON_BUILD/$PKG_ADDON_ID/bin"

  cp -PR "$(get_build_dir python_sabnzbd)/.install_pkg/usr/lib" \
         "$ADDON_BUILD/$PKG_ADDON_ID"

  cp -PR "$PKG_BUILD"/* \
         "$ADDON_BUILD/$PKG_ADDON_ID/sabnzbd"
}
