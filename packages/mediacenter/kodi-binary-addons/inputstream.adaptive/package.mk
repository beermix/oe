################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################
################################################################################
################################################################################
################################################################################

PKG_NAME="inputstream.adaptive"
PKG_VERSION="a02656d"
PKG_LICENSE="GPL"
PKG_GIT_URL="https://github.com/peak3d/inputstream.adaptive"
#PKG_GIT_BRANCH="Krypton"
PKG_DEPENDS_TARGET="toolchain kodi-platform"
PKG_SECTION=""
PKG_SHORTDESC="inputstream.adaptive"
PKG_LONGDESC="inputstream.adaptive"

PKG_IS_ADDON="yes"

export CCACHE_DISABLE=1

post_makeinstall_target() {
  mkdir -p wv && cd wv
    cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DDECRYPTERPATH=special://home/cdm \
        $PKG_BUILD/wvdecrypter
    make

  cp -P $ROOT/$PKG_BUILD/.$TARGET_NAME/wv/libssd_wv.so $INSTALL/usr/lib
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/
  cp -R $ROOT/$PKG_BUILD/.install_pkg/usr/share/$MEDIACENTER/addons/$PKG_NAME/* $ADDON_BUILD/$PKG_ADDON_ID/

  ADDONSO=$(xmlstarlet sel -t -v "/addon/extension/@library_linux" $ADDON_BUILD/$PKG_ADDON_ID/addon.xml)
  cp -L $ROOT/$PKG_BUILD/.install_pkg/usr/lib/$MEDIACENTER/addons/$PKG_NAME/$ADDONSO $ADDON_BUILD/$PKG_ADDON_ID/

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib/
  cp -P $ROOT/$PKG_BUILD/.$TARGET_NAME/wv/libssd_wv.so $ADDON_BUILD/$PKG_ADDON_ID/lib
}
