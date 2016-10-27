PKG_NAME="vlc"
PKG_VERSION="2.2.4"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.videolan.org"
PKG_URL="http://download.videolan.org/pub/videolan/vlc/$PKG_VERSION/vlc-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libdvbpsi ffmpeg x264 mesa flac madplay libgcrypt libsamplerate libjpeg-turbo libsamplerate libdvdnav SDL2 libva"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="VideoLAN multimedia player and streamer"
PKG_LONGDESC="VLC is the VideoLAN project's media player. It plays MPEG, MPEG2, MPEG4, DivX, MOV, WMV, QuickTime, mp3, Ogg/Vorbis files, DVDs, VCDs, and multimedia streams from various network sources."
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --disable-mmx \
			   --sysconfdir=/storage/.config \
                           --datadir=/storage/.config \
                           --libdir=/storage/.config \
                           --libexecdir=/storage/.config \
			   --enable-sse \
			   --disable-nls \
			   --disable-optimizations \
			   --disable-rpath \
			   --disable-a52 \
			   --enable-avcodec \
			   --enable-avformat \
			   --enable-bluray \
			   --enable-dbus \
			   --disable-dc1394 \
			   --enable-dvbpsi \
			   --enable-dvdread \
			   --enable-dvdnav \
			   --disable-faad \
			   --enable-flac \
			   --enable-httpd \
			   --enable-libcddb \
			   --enable-libva \
			   --disable-live555 \
			   --enable-merge-ffmpeg \
			   --enable-realrtsp \
			   --enable-sdl \
			   --disable-jack \
			   --disable-projectm \
			   --enable-jpeg \
			   --disable-x262 \
			   --disable-libx265 \
			   --disable-x265 \
			   --disable-vdpau \
			   --disable-atmo \
			   --enable-run-as-root \
			   --enable-png \
			   --enable-libcddb \
			   --disable-lua \
			   --enable-static \
			   --enable-samplerate"
