################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="tvheadend"
PKG_VERSION="39108ce"
TVH_VERSION="4.1.2281"
PKG_REV="2"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvheadend.org"
PKG_URL="https://github.com/tvheadend/tvheadend/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain curl libdvbcsa libiconv libressl Python2:host yasm libva-intel-driver"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tvservice"
PKG_SHORTDESC="Tvheadend: a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources."
PKG_LONGDESC="Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources. It also comes with a powerful and easy to use web interface both used for configuration and day-to-day operations, such as searching the EPG and scheduling recordings. Even so, the most notable feature of Tvheadend is how easy it is to set up: Install it, navigate to the web user interface, drill into the TV adapters tab, select your current location and Tvheadend will start scanning channels and present them to you in just a few minutes. If installing as an Addon a reboot is needed"


PKG_LOCALE_INSTALL="yes"

post_unpack() {
  sed -e 's/VER="0.0.0~unknown"/VER="'$TVH_VERSION'~g'$PKG_VERSION'~AlexELEC"/g' -i $PKG_BUILD/support/version
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --arch=$TARGET_ARCH \
                           --cpu=$TARGET_CPU \
                           --cc=$TARGET_CC \
                           --disable-avahi \
                           --enable-bundle \
                           --disable-dbus_1 \
                           --enable-dvbcsa \
                           --disable-dvben50221 \
                           --disable-hdhomerun_client \
                           --disable-hdhomerun_static \
                           --enable-epoll \
                           --enable-inotify \
                           --disable-nvenc \
                           --disable-uriparser \
                           --enable-ffmpeg_static \
                           --enable-libav \
                           --enable-libfdkaac \
                           --disable-libtheora \
                           --enable-libvorbis \
                           --enable-libvpx \
                           --enable-libx264 \
                           --enable-libx265 \
                           --disable-qsv \
                           --enable-tvhcsa \
                           --enable-trace \
                           --enable-timeshift \
                           --disable-dvbscan \
                           --nowerror \
                           --python=$TOOLCHAIN/bin/python"

pre_configure_target() {
# fails to build in subdirs
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME

  export AS=$TOOLCHAIN/bin/yasm
  export CROSS_COMPILE=$TARGET_PREFIX
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/iconv -L$SYSROOT_PREFIX/usr/lib/iconv -logg"
}

pre_make_target() {
    export CXX="$TARGET_CXX -std=gnu++98"
}


post_make_target() {
  $CC -O -fbuiltin -fomit-frame-pointer -fPIC -shared -o capmt_ca.so src/extra/capmt_ca.c -ldl
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P capmt_ca.so $INSTALL/usr/lib

  mkdir -p $INSTALL/usr/bin
    cp -P $PKG_DIR/scripts/* $INSTALL/usr/bin
    cp -P support/sat_xml_scan.py $INSTALL/usr/bin/sat_xml_scan

  #sat files
  mkdir -p  $INSTALL/usr/config/tvheadend
    cp -a $PKG_DIR/config/* $INSTALL/usr/config/tvheadend
  mkdir -p $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/atsc $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-c $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-s $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/dvb-t $INSTALL/usr/config/tvheadend/dvb-scan
    cp -a data/dvb-scan/isdb-t $INSTALL/usr/config/tvheadend/dvb-scan
}
