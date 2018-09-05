# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="kodi"
PKG_VERSION="17.6-Krypton"
PKG_SHA256="c8312fe92e5bab1cdac1da93d60baed88fa1574146c50c44e3c86d01671c2b1d"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/xbmc/xbmc/tree/Krypton"
PKG_URL="https://github.com/xbmc/xbmc/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="xbmc-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain JsonSchemaBuilder:host TexturePacker:host xmlstarlet:host Python2 zlib systemd pciutils lzo pcre swig:host libass curl fontconfig fribidi tinyxml libjpeg-turbo freetype libcdio taglib libxml2 libxslt yajl sqlite crossguid giflib libdvdnav"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi: Kodi Mediacenter"
PKG_LONGDESC="Kodi Media Center (which was formerly named Xbox Media Center or XBMC) is a free and open source cross-platform media player and home entertainment system software with a 10-foot user interface designed for the living-room TV. Its graphical user interface allows the user to easily manage video, photos, podcasts, and music from a computer, optical disk, local network, and the internet using a remote control."
# Single threaded LTO is very slow so rely on Kodi for LTO support
PKG_BUILD_FLAGS="-lto"
#PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_SCRIPT="$PKG_BUILD/project/cmake/CMakeLists.txt"

  get_graphicdrivers

  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET dbus"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXext libdrm libXrandr"
  KODI_XORG="-DENABLE_X11=ON"
else
  KODI_XORG="-DENABLE_X11=OFF"
fi

if [ ! "$OPENGL" = "no" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL glu"
  KODI_OPENGL="-DENABLE_OPENGL=ON"
else
  KODI_OPENGL="-DENABLE_OPENGL=OFF"
fi

if [ "$OPENGLES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
  KODI_OPENGLES="-DENABLE_OPENGLES=ON"
else
  KODI_OPENGLES="-DENABLE_OPENGLES=OFF"
fi

if [ "$ALSA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET alsa-lib"
  KODI_ALSA="-DENABLE_ALSA=ON"
else
  KODI_ALSA="-DENABLE_ALSA=OFF"
fi

if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pulseaudio"
  KODI_PULSEAUDIO="-DENABLE_PULSEAUDIO=ON"
else
  KODI_PULSEAUDIO="-DENABLE_PULSEAUDIO=OFF"
fi

if [ "$ESPEAK_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET espeak"
fi

if [ "$CEC_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libcec"
  KODI_CEC="-DENABLE_CEC=ON"
else
  KODI_CEC="-DENABLE_CEC=OFF"
fi

if [ "$KODI_OPTICAL_SUPPORT" = yes ]; then
  KODI_OPTICAL="-DENABLE_OPTICAL=ON"
else
  KODI_OPTICAL="-DENABLE_OPTICAL=OFF"
fi

if [ "$KODI_NONFREE_SUPPORT" = yes ]; then
  KODI_NONFREE="-DENABLE_NONFREE=ON"
else
  KODI_NONFREE="-DENABLE_NONFREE=OFF"
fi

if [ "$KODI_DVDCSS_SUPPORT" = yes ]; then
  KODI_DVDCSS="-DENABLE_DVDCSS=ON \
               -DLIBDVDCSS_URL=$SOURCES/libdvdcss/libdvdcss-$(get_pkg_version libdvdcss).tar.gz"
else
  KODI_DVDCSS="-DENABLE_DVDCSS=OFF"
fi

if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libbluray"
  KODI_BLURAY="-DENABLE_BLURAY=ON"
else
  KODI_BLURAY="-DENABLE_BLURAY=OFF"
fi

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi nss-mdns"
  KODI_AVAHI="-DENABLE_AVAHI=ON"
else
  KODI_AVAHI="-DENABLE_AVAHI=OFF"
fi

case "$KODI_MYSQL_SUPPORT" in
  mysql)   PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mysql"
           KODI_MYSQL="-DENABLE_MYSQLCLIENT=ON -DENABLE_MARIADBCLIENT=OFF"
           ;;
  mariadb) PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mariadb-connector-c"
           KODI_MYSQL="-DENABLE_MARIADBCLIENT=ON -DENABLE_MYSQLCLIENT=OFF"
           ;;
  *)       KODI_MYSQL="-DENABLE_MYSQLCLIENT=OFF -DENABLE_MARIADBCLIENT=OFF"
esac

if [ "$KODI_AIRPLAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libplist"
  KODI_AIRPLAY="-DENABLE_PLIST=ON"
else
  KODI_AIRPLAY="-DENABLE_PLIST=OFF"
fi

if [ "$KODI_AIRTUNES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libshairplay"
  KODI_AIRTUNES="-DENABLE_AIRTUNES=ON"
else
  KODI_AIRTUNES="-DENABLE_AIRTUNES=OFF"
fi

if [ "$KODI_NFS_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libnfs"
  KODI_NFS="-DENABLE_NFS=ON"
else
  KODI_NFS="-DENABLE_NFS=OFF"
fi

if [ "$KODI_SAMBA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET samba"
  KODI_SAMBA="-DENABLE_SMBCLIENT=ON"
else
  KODI_SAMBA="-DENABLE_SMBCLIENT=OFF"
fi

if [ "$KODI_WEBSERVER_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libmicrohttpd"
fi

if [ "$KODI_UPNP_SUPPORT" = yes ]; then
  KODI_UPNP="-DENABLE_UPNP=ON"
else
  KODI_UPNP="-DENABLE_UPNP=OFF"
fi

if [ "$KODI_SSHLIB_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libssh"
  KODI_SSH="-DENABLE_SSH=ON"
else
  KODI_SSH="-DENABLE_SSH=OFF"
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
  KODI_VDPAU="-DENABLE_VDPAU=ON"
else
  KODI_VDPAU="-DENABLE_VDPAU=OFF"
fi

if [ "$VAAPI_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva"
  KODI_VAAPI="-DENABLE_VAAPI=ON"
else
  KODI_VAAPI="-DENABLE_VAAPI=OFF"
fi

if [ "$TARGET_ARCH" = "x86_64" ]; then
  KODI_ARCH="-DWITH_CPU=$TARGET_ARCH"
else
  KODI_ARCH="-DWITH_ARCH=$TARGET_ARCH"
fi

if [ "$DEVICE" = "Slice" -o "$DEVICE" = "Slice3" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET led_tools"
fi

if [ ! "$KODIPLAYER_DRIVER" = default ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $KODIPLAYER_DRIVER libinput libxkbcommon"
  if [ "$KODIPLAYER_DRIVER" = bcm2835-driver ]; then
    KODI_PLAYER="-DCORE_PLATFORM_NAME=rbpi"
  elif [ "$KODIPLAYER_DRIVER" = mesa -o "$KODIPLAYER_DRIVER" = rkmpp ]; then
    KODI_PLAYER="-DCORE_PLATFORM_NAME=gbm"
    CFLAGS="$CFLAGS -DMESA_EGL_NO_X11_HEADERS"
    CXXFLAGS="$CXXFLAGS -DMESA_EGL_NO_X11_HEADERS"
  elif [ "$KODIPLAYER_DRIVER" = libamcodec ]; then
    KODI_PLAYER="-DCORE_PLATFORM_NAME=aml"
  fi
fi

KODI_LIBDVD="$KODI_DVDCSS \
             -DLIBDVDNAV_URL=$SOURCES/libdvdnav/libdvdnav-$(get_pkg_version libdvdnav).tar.gz \
             -DLIBDVDREAD_URL=$SOURCES/libdvdread/libdvdread-$(get_pkg_version libdvdread).tar.gz"

PKG_CMAKE_OPTS_TARGET="-DNATIVEPREFIX=$TOOLCHAIN \
                       -DWITH_TEXTUREPACKER=$TOOLCHAIN/bin/TexturePacker \
                       -DDEPENDS_PATH=$PKG_BUILD/depends \
                       -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/$PKG_PYTHON_VERSION \
                       -DPYTHON_INCLUDE_DIRS=$SYSROOT_PREFIX/usr/include/$PKG_PYTHON_VERSION \
                       -DGIT_VERSION=$PKG_VERSION \
                       -DENABLE_INTERNAL_FFMPEG=ON \
                       -DFFMPEG_INCLUDE_DIRS=$SYSROOT_PREFIX/usr \
                       -DDEPENDS_PATH=$SYSROOT_PREFIX/usr \
                       -DENABLE_INTERNAL_CROSSGUID=OFF \
                       -DENABLE_SDL=OFF \
                       -DENABLE_OPENSSL=ON \
                       -DENABLE_UDEV=ON \
                       -DENABLE_DBUS=ON \
                       -DENABLE_XSLT=OFF \
                       -DENABLE_CCACHE=ON \
                       -DENABLE_LIRC=OFF \
                       -DENABLE_EVENTCLIENTS=ON \
                       -DENABLE_LDGOLD=ON \
                       -DENABLE_DEBUGFISSION=OFF \
                       -DENABLE_APP_AUTONAME=OFF \
                       $PKG_KODI_USE_LTO \
                       $KODI_ARCH \
                       $KODI_OPENGL \
                       $KODI_OPENGLES \
                       $KODI_OPENMAX \
                       $KODI_VDPAU \
                       $KODI_VAAPI \
                       $KODI_CEC \
                       $KODI_XORG \
                       $KODI_SAMBA \
                       $KODI_NFS \
                       $KODI_LIBDVD \
                       $KODI_AVAHI \
                       $KODI_UPNP \
                       $KODI_MYSQL \
                       $KODI_SSH \
                       $KODI_AIRPLAY \
                       $KODI_AIRTUNES \
                       $KODI_NONFREE \
                       $KODI_OPTICAL \
                       $KODI_BLURAY \
                       $KODI_PLAYER"

#pre_configure_target() {
# kodi should never be built with lto
#  export LIBS="$LIBS -lz -lterminfo"
#}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/kodi
  rm -rf $INSTALL/usr/bin/kodi-standalone
  rm -rf $INSTALL/usr/bin/xbmc
  rm -rf $INSTALL/usr/bin/xbmc-standalone
  rm -rf $INSTALL/usr/share/kodi/cmake
  rm -rf $INSTALL/usr/share/applications
  rm -rf $INSTALL/usr/share/icons
  rm -rf $INSTALL/usr/share/pixmaps
  rm -rf $INSTALL/usr/share/kodi/addons/skin.estouchy
  rm -rf $INSTALL/usr/share/kodi/addons/skin.estuary
  rm -rf $INSTALL/usr/share/kodi/addons/service.xbmc.versioncheck
  rm -rf $INSTALL/usr/share/kodi/addons/visualization.vortex
  rm -rf $INSTALL/usr/share/xsessions

  mv $INSTALL/usr/lib/python2.7/dist-packages $INSTALL/usr/lib/python2.7/site-packages

  mkdir -p $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-config $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi.sh $INSTALL/usr/lib/kodi

  mkdir -p $INSTALL/usr/lib/libreelec
    cp $PKG_DIR/scripts/systemd-addon-wrapper $INSTALL/usr/lib/libreelec

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/cputemp $INSTALL/usr/bin
      ln -sf cputemp $INSTALL/usr/bin/gputemp
    cp $PKG_DIR/scripts/setwakeup.sh $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/share/kodi/addons
    cp -R $PKG_DIR/config/os.openelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.openelec.tv/addon.xml
    cp -R $PKG_DIR/config/os.libreelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.libreelec.tv/addon.xml
    cp -R $PKG_DIR/config/repository.libreelec.tv $INSTALL/usr/share/kodi/addons
    $SED "s|@ADDON_URL@|$ADDON_URL|g" -i $INSTALL/usr/share/kodi/addons/repository.libreelec.tv/addon.xml

  mkdir -p $INSTALL/usr/share/kodi/config
    cp $PKG_DIR/config/guisettings.xml $INSTALL/usr/share/kodi/config
    cp $PKG_DIR/config/sources.xml $INSTALL/usr/share/kodi/config

# install project specific configs
    if [ -n "$DEVICE" -a -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/guisettings.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/guisettings.xml $INSTALL/usr/share/kodi/config
    elif [ -f $PROJECT_DIR/$PROJECT/kodi/guisettings.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/kodi/guisettings.xml $INSTALL/usr/share/kodi/config
    fi

    if [ -n "$DEVICE" -a -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/sources.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/sources.xml $INSTALL/usr/share/kodi/config
    elif [ -f $PROJECT_DIR/$PROJECT/kodi/sources.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/kodi/sources.xml $INSTALL/usr/share/kodi/config
    fi

  mkdir -p $INSTALL/usr/share/kodi/system/
    if [ -n "$DEVICE" -a -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/advancedsettings.xml ]; then
      cp $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/advancedsettings.xml $INSTALL/usr/share/kodi/system/
    elif [ -f $PROJECT_DIR/$PROJECT/kodi/advancedsettings.xml ]; then
      cp $PROJECT_DIR/$PROJECT/kodi/advancedsettings.xml $INSTALL/usr/share/kodi/system/
    else
      cp $PKG_DIR/config/advancedsettings.xml $INSTALL/usr/share/kodi/system/
    fi

  mkdir -p $INSTALL/usr/share/kodi/system/settings
    if [ -n "$DEVICE" -a -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/appliance.xml ]; then
      cp $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/appliance.xml $INSTALL/usr/share/kodi/system/settings
    elif [ -f $PROJECT_DIR/$PROJECT/kodi/appliance.xml ]; then
      cp $PROJECT_DIR/$PROJECT/kodi/appliance.xml $INSTALL/usr/share/kodi/system/settings
    else
      cp $PKG_DIR/config/appliance.xml $INSTALL/usr/share/kodi/system/settings
    fi

  # update addon manifest
  ADDON_MANIFEST=$INSTALL/usr/share/kodi/system/addon-manifest.xml
  xmlstarlet ed -L -d "/addons/addon[text()='service.xbmc.versioncheck']" $ADDON_MANIFEST
  xmlstarlet ed -L -d "/addons/addon[text()='skin.estouchy']" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.libreelec.tv" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.openelec.tv" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "repository.libreelec.tv" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.libreelec.settings" $ADDON_MANIFEST
  if [ "$PROJECT" = "Slice" -o "$PROJECT" = "Slice3" ]; then
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.slice" $ADDON_MANIFEST
  fi

  # more binaddons cross compile badness meh
  sed -e "s:INCLUDE_DIR /usr/include/kodi:INCLUDE_DIR $SYSROOT_PREFIX/usr/include/kodi:g" \
      -e "s:CMAKE_MODULE_PATH /usr/lib/kodi /usr/share/kodi/cmake:CMAKE_MODULE_PATH $SYSROOT_PREFIX/usr/share/kodi/cmake:g" \
      -i $SYSROOT_PREFIX/usr/share/kodi/cmake/KodiConfig.cmake

  if [ "$KODI_EXTRA_FONTS" = yes ]; then
    mkdir -p $INSTALL/usr/share/kodi/media/Fonts
      cp $PKG_DIR/fonts/*.ttf $INSTALL/usr/share/kodi/media/Fonts
  fi

  debug_strip $INSTALL/usr/lib/kodi/kodi.bin
}

post_install() {
  enable_service kodi.target
  enable_service kodi-autostart.service
  enable_service kodi-cleanlogs.service
  enable_service kodi-halt.service
  enable_service kodi-poweroff.service
  enable_service kodi-reboot.service
  enable_service kodi-waitonnetwork.service
  enable_service kodi.service
  enable_service kodi-lirc-suspend.service
}
