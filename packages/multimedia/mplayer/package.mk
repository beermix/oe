PKG_NAME="mplayer"
PKG_VERSION="export-2017-10-06"
PKG_URL="ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-export-snapshot.tar.bz2"
#PKG_SOURCE_DIR="mplayer-export-2017-10-06"
PKG_DEPENDS_TARGET="toolchain ffmpeg"

PKG_AUTORECONF="no"

get_graphicdrivers

pre_configure_target() {
  cd $PKG_BUILD
  strip_lto
  strip_gold
}

configure_target() {  
  ./configure --enable-runtime-cpudetection \
  		--disable-inet6 \
  		--enable-big-endian \
  		--prefix=/usr \
  		--yasm=$TOOLCHAIN/bin/yasm  \
  		--nm="$NM" \
  		--ar="$AR" \
  		--as="$CC" \
  		--cc="$CC" \
  		--host-cc="$HOST_CC" \
  		--enable-mmx \
  		--enable-sse \
  		--enable-sse2 \
  		--enable-sse3 \
  		--enable-ssse3 \
  		--enable-sse4 \
  		--enable-avx \
  		--disable-iconv \
  		--disable-smb \
  		--disable-faac
}
