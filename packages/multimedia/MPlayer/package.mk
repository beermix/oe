PKG_NAME="MPlayer"
PKG_VERSION="1.3.0"
PKG_URL="ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz"
#PKG_SOURCE_DIR="mplayer-export-2017-04-14"
PKG_DEPENDS_TARGET="toolchain ffmpeg faad2"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  strip_lto
  strip_gold
}

configure_target() {  
  ./configure --enable-runtime-cpudetection \
  		--disable-inet6 \
  		--enable-big-endian \
  		--prefix=/usr \
  		--yasm=$ROOT/$TOOLCHAIN/bin/yasm  \
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
  		--enable-faad \
  		--disable-faac
}
