################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vlc"
PKG_VERSION="2.2.5.1"
PKG_URL="https://nightlies.videolan.org/build/source/vlc-2.2.5-20170321-0224.1.tar.xz"
#PKG_VERSION="2.2.4"
#PKG_URL="http://download.videolan.org/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain dbus libdvbpsi gnutls ffmpeg alsa-lib libmpeg2 libvorbis gstreamer zlib lua:host lua"
PKG_SECTION="xmedia/tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-silent-rules \
			      --disable-dependency-tracking \
			      --without-contrib \
			      --disable-nls \
			      --disable-rpath \
			      --disable-dbus \
			      --disable-gprof \
			      --disable-cprof \
			      --disable-debug \
			      --enable-run-as-root \
			      --disable-coverage \
			      --disable-sout \
			      --enable-lua \
			      --disable-httpd \
			      --disable-vlm \
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
			      --disable-vcd \
			      --disable-libcddb \
			      --enable-dvbpsi \
			      --disable-screen \
			      --enable-ogg \
			      --disable-shout\
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
			      --disable-swscale \
			      --enable-postproc \
			      --disable-faad \
			      --enable-flac \
			      --enable-aa \
			      --disable-twolame \
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
			      --disable-macosx-vlc-app \
			      --disable-macosx-qtkit \
			      --enable-ncurses \
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
			      --disable-atmo \
			      --disable-vsxu \
			      --disable-projectm \
			      --disable-goom \
			      --disable-mfx \
			      --disable-vda \
			      --disable-vcd \
			      --disable-mmal-codec \
			      --disable-mmal-vout \
			      --disable-jpeg \
			      --disable-x262 \
			      --disable-x265 \
			      --disable-addonmanagermodules \
			      --disable-chromaprint \
			      --disable-decklink \
			      --enable-optimize-memory \
			      --enable-sse \
			      --enable-mmx \
			      --enable-optimizations \
			      --disable-directfb"

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -lresolv"
  #export LIBS="-latomic"
  strip_lto
  #strip_gold
  #strip_hard
}

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
