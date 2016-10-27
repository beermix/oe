PKG_NAME="mc"
PKG_VERSION="4.8.16"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.midnight-commander.org"
PKG_URL="http://ftp.midnight-commander.org/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host glib pcre netbsd-curses"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_IS_ADDON="no"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_AUTORECONF="yes"



PKG_CONFIGURE_TARGET="--sysconfdir="/storage/.kodi/addons/tools.mc/etc" --datadir="/storage/.kodi/addons/tools.mc/data"--libdir="/storage/.kodi/addons/tools.mc/mclib" \
                    --disable-mclib \
                    --disable-aspell \
                    --disable-rpath \
                    --enable-vfs \
                    --disable-doxygen-doc \
                    --disable-doxygen-dot \
                    --disable-doxygen-html \
                    --with-screen=ncurses \
                    --with-sysroot=$SYSROOT_PREFIX \
                    --without-x \
                    --with-gnu-ld \
                    --without-libiconv-prefix \
                    --without-libintl-prefix \
                    --without-internal-edit \
                    --with-diff-viewer \
                    --with-subshell"

pre_configure_target() {
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/ncurses"
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`
}

post_makeinstall_target() {
  rm -rf $INSTALL/storage/.kodi/addons/tools.mc/data/locale
  rm -rf $INSTALL/storage/.kodi/addons/tools.mc/data/mc/help/mc.hlp.*
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -Pa $PKG_BUILD/.install_pkg/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin/
  cp -Pa $PKG_BUILD/.install_pkg/storage/.kodi/addons/tools.mc/* $ADDON_BUILD/$PKG_ADDON_ID
}