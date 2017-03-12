################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vlc"
PKG_VERSION="2.2.5"
PKG_URL="https://nightlies.videolan.org/build/source/vlc-2.2.5-20170311-0221.1.tar.xz"
#PKG_VERSION="2.2.4"
#PKG_SITE="http://www.videolan.org"
#PKG_URL="http://download.videolan.org/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain dbus libdvbpsi ffmpeg zlib lua libvorbis libogg flac gnutls libmpeg2"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/tools"
PKG_SHORTDESC="VideoLAN multimedia player and streamer"
PKG_LONGDESC="VLC is the VideoLAN project's media player. It plays MPEG, MPEG2, MPEG4, DivX, MOV, WMV, QuickTime, mp3, Ogg/Vorbis files, DVDs, VCDs, and multimedia streams from various network sources."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
# vlc fails to build with LTO optimization
  strip_lto
  
  export LUA_LIBS="-L$SYSROOT_PREFIX/usr/lib -llua -lm"
  #export LIBS="-lterminfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-silent-rules \
			      --disable-dependency-tracking \
			      --without-contrib \
			      --disable-nls \
			      --disable-rpath \
			      --enable-dbus \
			      --disable-gprof \
			      --disable-cprof \
			      --disable-debug \
			      --enable-run-as-root \
			      --disable-coverage \
			      --enable-sout \
			      --enable-lua \
			      --enable-httpd \
			      --enable-vlm \
			      --disable-growl \
			      --disable-notify \
			      --disable-taglib \
			      --disable-live555 \
			      --disable-dc1394 \
			      --disable-dvdread \
			      --disable-dvdnav \
			      --disable-opencv \
			      --disable-decklink \
			      --disable-sftp \
			      --enable-v4l2 \
			      --disable-gnomevfs \
			      --disable-vcdx \
			      --disable-vcd \
			      --disable-libcddb \
			      --enable-dvbpsi \
			      --disable-screen \
			      --enable-ogg \
			      --enable-mux_ogg \
			      --disable-shout\
			      --disable-mkv \
			      --disable-mod \
			      --enable-mpc \
			      --disable-gme \
			      --disable-wma-fixed \
			      --disable-shine \
			      --disable-omxil \
			      --disable-mad \
			      --disable-merge-ffmpeg \
			      --enable-avcodec \
			      --enable-avformat \
			      --enable-swscale \
			      --enable-postproc \
			      --disable-faad \
			      --enable-flac \
			      --enable-aa \
			      --disable-twolame \
			      --disable-quicktime \
			      --disable-realrtsp \
			      --disable-libtar \
			      --disable-a52 \
			      --disable-dca \
			      --enable-libmpeg2 \
			      --enable-vorbis \
			      --disable-tremor \
			      --disable-speex \
			      --disable-theora \
			      --disable-schroedinger \
			      --disable-png \
			      --disable-x264 \
			      --disable-fluidsynth \
			      --disable-zvbi \
			      --disable-telx \
			      --disable-libass \
			      --disable-kate \
			      --disable-tiger \
			      --disable-libva \
			      --disable-vdpau \
			      --without-x \
			      --disable-xcb \
			      --disable-xvideo \
			      --disable-sdl \
			      --disable-sdl-image \
			      --disable-freetype \
			      --disable-fribidi \
			      --disable-fontconfig \
			      --enable-libxml2 \
			      --disable-svg \
			      --disable-directx \
			      --disable-directfb \
			      --disable-caca \
			      --disable-oss \
			      --disable-pulse \
			      --enable-alsa \
			      --disable-jack \
			      --disable-upnp \
			      --disable-skins2 \
			      --disable-kai \
			      --disable-macosx \
			      --disable-macosx-dialog-provider \
			      --disable-macosx-eyetv \
			      --disable-macosx-vlc-app \
			      --disable-macosx-qtkit \
			      --disable-macosx-quartztext \
			      --disable-ncurses \
			      --disable-goom \
			      --disable-projectm \
			      --disable-atmo \
			      --disable-bonjour \
			      --enable-udev \
			      --disable-mtp \
			      --disable-lirc \
			      --disable-libgcrypt \
			      --enable-gnutls \
			      --disable-update-check \
			      --disable-kva \
			      --disable-bluray \
			      --disable-samplerate \
			      --disable-sid \
			      --disable-crystalhd \
			      --disable-dxva2 \
			      --enable-vlc \
			      LUAC=$SYSROOT_PREFIX/usr/bin/luac"

post_makeinstall_target() {
  rm -fr $INSTALL/usr/share/applications
  rm -fr $INSTALL/usr/share/icons
  rm -fr $INSTALL/usr/share/kde4
  rm -f $INSTALL/usr/bin/rvlc
  rm -f $INSTALL/usr/bin/vlc-wrapper

  mkdir -p $INSTALL/usr/config
    mv -f $INSTALL/usr/lib/vlc $INSTALL/usr/config
    ln -sf /storage/.config/vlc $INSTALL/usr/lib/vlc
}
