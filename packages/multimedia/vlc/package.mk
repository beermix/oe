################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="vlc"
PKG_VERSION="3.0.8"
PKG_SHA256="e0149ef4a20a19b9ecd87309c2d27787ee3f47dfd47c6639644bc1f6fd95bdf6"
#PKG_REV="20171107-0242"
#PKG_SITE="https://nightlies.videolan.org/build/source/"
#PKG_URL="https://nightlies.videolan.org/build/source/vlc-3.0.0-$PKG_REV-git.tar.xz"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_SOURCE_DIR="vlc*"
PKG_DEPENDS_TARGET="toolchain dbus ffmpeg libdvbpsi libmpeg2 libogg libvorbis flac libsamplerate zlib lua:host lua gnutls"
PKG_SHORTDESC="VideoLAN multimedia player and streamer"
PKG_TOOLCHAIN="autotools"

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
			      --enable-sout \
			      --enable-lua \
			      --enable-httpd \
			      --enable-vlm \
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
			      --disable-shout \
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
			      --disable-realrtsp \
			      --disable-libtar \
			      --disable-a52 \
			      --disable-dca \
			      --enable-libmpeg2 \
			      --enable-vorbis \
			      --disable-tremor \
			      --enable-speex \
			      --disable-theora \
			      --disable-schroedinger \
			      --enable-png \
			      --disable-x264 \
			      --disable-fluidsynth \
			      --disable-zvbi \
			      --disable-telx \
			      --disable-libass \
			      --disable-kate \
			      --disable-tiger \
			      --enable-libva \
			      --disable-vdpau \
			      --with-x \
			      --enable-xcb \
			      --disable-xvideo \
			      --disable-sdl \
			      --disable-sdl-image \
			      --enable-freetype \
			      --enable-fribidi \
			      --enable-fontconfig \
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
			      --disable-goom \
			      --disable-projectm \
			      --enable-udev \
			      --disable-mtp \
			      --disable-lirc \
			      --disable-libgcrypt \
			      --enable-gnutls \
			      --disable-update-check \
			      --disable-kva \
			      --disable-bluray \
			      --enable-samplerate \
			      --disable-sid \
			      --disable-crystalhd \
			      --disable-dxva2 \
			      --disable-qt \
			      --enable-vlc \
			      --disable-wayland"

#pre_configure_target() {
#  export LDFLAGS="$LDFLAGS -lresolv"
#  export LIBS="$LIBS -fopenmp"
#}

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
